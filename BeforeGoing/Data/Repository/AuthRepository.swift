//
//  AuthRepository.swift
//  BeforeGoing
//
//  Created by APPLE on 7/22/25.
//

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
        
        return isCompletedOnboarding
    }
    
    func autoLogin() async throws -> Bool {
        guard isTokenExists, isCompletedOnboarding else { return false }
        
        guard let accessTokenExpirationDate = keyChainService.load(key: .accessTokenExpirationDate),
              let refreshTokenExpirationDate = keyChainService.load(key: .refreshTokenExpirationDate) else {
            return false
        }
        
        if !tokenValidator.isAccessTokenValid(expirationDate: accessTokenExpirationDate) {
            guard tokenValidator.isRefreshTokenValid(expirationDate: refreshTokenExpirationDate) else {
                return false
            }
            try await tokenReissuer.reissue()
        }
        return true
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
        let _ = userDefaultsService.save(provider.rawValue, key: .provider)
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
    
    private var isCompletedOnboarding: Bool {
        guard let isCompleted: Bool = userDefaultsService.load(key: .isCompletedOnboarding) else {
            return false
        }
        return isCompleted
    }
    
    private func deleteUserInformation() {
        for key in KeyChainKey.allCases {
            keyChainService.delete(key: key)
        }
        let _ = userDefaultsService.delete(key: .provider)
//        let _ = userDefaultsService.delete(key: (provider == Provider.apple.rawValue) ? .appleMemberName : .kakaoMemberName)
    }
}
