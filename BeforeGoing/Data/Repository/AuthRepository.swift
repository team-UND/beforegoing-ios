//
//  AuthRepository.swift
//  BeforeGoing
//
//  Created by APPLE on 7/22/25.
//

import Foundation

struct AuthRepository: AuthInterface {
    
    private let networkService: NetworkService
    private let tokenReissuer: TokenReissuer
    private let keyChainService: KeyChainService
    private let userDefaultsService: UserDefaultsService
    private let nonceRequestMapper: NonceRequestMapper
    private let loginRequestMapper: LoginRequestMapper
    private let tokenValidator: TokenValidator
    
    init(
        networkService: NetworkService,
        tokenReissuer: TokenReissuer,
        keyChainService: KeyChainService,
        userDefaultsService: UserDefaultsService,
        nonceRequestMapper: NonceRequestMapper,
        loginRequestMapper: LoginRequestMapper,
        tokenValidator: TokenValidator
    ) {
        self.networkService = networkService
        self.tokenReissuer = tokenReissuer
        self.keyChainService = keyChainService
        self.userDefaultsService = userDefaultsService
        self.nonceRequestMapper = nonceRequestMapper
        self.loginRequestMapper = loginRequestMapper
        self.tokenValidator = tokenValidator
    }
    
    func requestNonce(provider: Provider) async throws -> NonceEntity {
        let nonceRequestDTO = nonceRequestMapper.map(provider.rawValue)
        let response = try await networkService.request(
            endPoint: AuthAPI.nonce(dto: nonceRequestDTO),
            responseType: NonceResponseDTO.self
        )
        return response.toEntity()
    }
    
    func requestLogin(provider: Provider) async throws -> Bool {
        let nonceEntity = try await requestNonce(provider: provider)
        let idToken = try await requestIDToken(nonce: nonceEntity.nonce)
        
        return try await requestLogin(provider: provider, idToken: idToken)
    }
    
    func requestLogin(provider: Provider, idToken: String) async throws -> Bool {
        let requestDTO = loginRequestMapper.map((provider.rawValue, idToken))
        let response = try await networkService.request(
            endPoint: AuthAPI.login(dto: requestDTO),
            responseType: LoginResponseDTO.self
        )
        saveKeyChain(response: response)
        saveProvider(provider)
        
        return isCompletedOnboarding(provider: provider)
    }
    
    func autoLogin() async throws -> Bool {
        guard let providerString: String = userDefaultsService.load(key: .provider),
              let provider = Provider(rawValue: providerString) else {
            return false
        }
        
        guard let isCompletedOnboarding: Bool = (provider == .apple) ? userDefaultsService.load(
            key: .isAppleCompletedOnboarding) : userDefaultsService.load(key: .isKakaoCompletedOnboarding)
        else {
            return false
        }
        
        guard isTokenExists, isCompletedOnboarding else { return false }
        
        guard let accessTokenExpirationDate = keyChainService.load(key: .accessTokenExpirationDate),
              let refreshTokenExpirationDate = keyChainService.load(key: .refreshTokenExpirationDate) else {
            return false
        }
        
        if tokenValidator.isAccessTokenValid(expirationDate: accessTokenExpirationDate) {
            return true
        }
        
        if tokenValidator.isRefreshTokenValid(expirationDate: refreshTokenExpirationDate) {
            do {
                try await tokenReissuer.reissue()
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    func getLastLogin() -> Provider? {
        guard let lastLogin: LastLogin = userDefaultsService.load(key: .lastProvider) else {
            return nil
        }
        return Provider(rawValue: lastLogin.provider)
    }
    
    func logout() async throws {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return
        }
        try await networkService.request(endPoint: AuthAPI.logout(accessToken: accessToken))
        
        deleteUserInformation()
    }
    
    private func requestIDToken(nonce: String?) async throws -> String {
        return try await networkService.requestKakaoIDToken(nonce: nonce)
    }
    
    private func saveKeyChain(response: LoginResponseDTO) {
        let responseData: [KeyChainKey: String] = [
            .accessToken: response.accessToken,
            .refreshToken: response.refreshToken,
            .accessTokenExpirationDate: tokenValidator.calculateExpirationDate(
                expiresIn: response.accessTokenExpiresIn
            ),
            .refreshTokenExpirationDate: tokenValidator.calculateExpirationDate(
                expiresIn: response.refreshTokenExpiresIn
            )
        ]
        
        for data in responseData {
            keyChainService.save(data.value, forKey: data.key)
        }
    }
    
    private func saveProvider(_ provider: Provider) {
        let lastLogin = LastLogin(provider: provider.rawValue, timestamp: Date())
        
        let _ = userDefaultsService.save(provider.rawValue, key: .provider)
        let _ = userDefaultsService.save(lastLogin, key: .lastProvider)
    }
    
    private var isTokenExists: Bool {
        if let accessToken = keyChainService.load(key: .accessToken),
           let refreshToken = keyChainService.load(key: .refreshToken),
           !accessToken.isEmpty,
           !refreshToken.isEmpty {
            return true
        }
        return false
    }
    
    private func isCompletedOnboarding(provider: Provider) -> Bool {
        let key: UserDefaultsKey = (provider == .apple) ? .isAppleCompletedOnboarding : .isKakaoCompletedOnboarding
        
        guard let isCompleted: Bool = userDefaultsService.load(key: key) else {
            return false
        }
        return isCompleted
    }
    
    private func deleteUserInformation() {
        for key in KeyChainKey.allCases {
            keyChainService.delete(key: key)
        }
        let _ = userDefaultsService.delete(key: .provider)
    }
}
