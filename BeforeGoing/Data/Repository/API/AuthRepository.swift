//
//  AuthRepository.swift
//  BeforeGoing
//
//  Created by APPLE on 7/22/25.
//

import Foundation

struct AuthRepository: AuthInterface {
    
    private let userDefaultsService: UserDefaultsService
    
    init(userDefaultsService: UserDefaultsService) {
        self.userDefaultsService = userDefaultsService
    }
    
    func login() -> Bool {
        guard let _: String = userDefaultsService.load(key: .userID) else {
            return false
        }
        return true
    }
    
//    func requestNonce(provider: Provider) async throws -> NonceEntity {
//        let nonceRequestDTO = nonceRequestMapper.map(provider.rawValue)
//        let response = try await networkService.request(
//            endPoint: AuthAPI.nonce(dto: nonceRequestDTO),
//            responseType: NonceResponseDTO.self
//        )
//        return response.toEntity()
//    }
//    
//    func requestLogin(provider: Provider) async throws -> Bool {
//        let nonceEntity = try await requestNonce(provider: provider)
//        let idToken = try await requestIDToken(nonce: nonceEntity.nonce)
//        
//        return try await requestLogin(provider: provider, idToken: idToken)
//    }
//    
//    private func requestLogin(provider: Provider, idToken: String) async throws -> Bool {
//        let requestDTO = loginRequestMapper.map((provider.rawValue, idToken))
//        let response = try await networkService.request(
//            endPoint: AuthAPI.login(dto: requestDTO),
//            responseType: LoginResponseDTO.self
//        )
//        saveKeyChain(response: response)
//        saveProvider(provider)
//        
//        let isAgreedTerms = try await isAgreedTerms(accessToken: response.accessToken)
//        let isCompletedJoin = !response.isNewMember && isAgreedTerms
//        return isCompletedJoin
//    }
//    
//    func requestLogin(provider: Provider, idToken: String, name: String?) async throws -> Bool {
//        let isCompletedJoin = try await requestLogin(provider: provider, idToken: idToken)
//        
//        if let name,
//           !name.isBlank,
//           let accessToken = keyChainService.load(key: .accessToken) {
//            try await networkService.request(
//                endPoint: MemberAPI.updateNickname(
//                    accessToken: accessToken,
//                    dto: .init(nickname: name)
//                )
//            )
//        }
//        
//        return isCompletedJoin
//    }
//    
//    func autoLogin() async throws -> Bool {
//        guard let accessToken = keyChainService.load(key: .accessToken) else {
//            return false
//        }
//        
//        guard isTokenExists,
//              try await isAgreedTerms(accessToken: accessToken) else {
//            return false
//        }
//        
//        guard let accessTokenExpirationDate = keyChainService.load(key: .accessTokenExpirationDate),
//              let refreshTokenExpirationDate = keyChainService.load(key: .refreshTokenExpirationDate) else {
//            return false
//        }
//        
//        if tokenValidator.isAccessTokenValid(expirationDate: accessTokenExpirationDate) {
//            return true
//        }
//        
//        if tokenValidator.isRefreshTokenValid(expirationDate: refreshTokenExpirationDate) {
//            do {
//                try await tokenReissuer.reissue()
//                return true
//            } catch {
//                return false
//            }
//        }
//        return false
//    }
//    
//    func getLastLogin() -> Provider? {
//        guard let lastLogin: LastLogin = userDefaultsService.load(key: .lastProvider) else {
//            return nil
//        }
//        return Provider(rawValue: lastLogin.provider)
//    }
//    
//    func logout() async throws {
//        guard let accessToken = keyChainService.load(key: .accessToken) else {
//            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
//            return
//        }
//        try await networkService.request(endPoint: AuthAPI.logout(accessToken: accessToken))
//        
//        deleteUserInformation()
//    }
//    
//    private func requestIDToken(nonce: String?) async throws -> String {
//        return try await networkService.requestKakaoIDToken(nonce: nonce)
//    }
//    
//    private func saveKeyChain(response: LoginResponseDTO) {
//        let responseData: [KeyChainKey: String] = [
//            .accessToken: response.accessToken,
//            .refreshToken: response.refreshToken,
//            .accessTokenExpirationDate: tokenValidator.calculateExpirationDate(
//                expiresIn: response.accessTokenExpiresIn
//            ),
//            .refreshTokenExpirationDate: tokenValidator.calculateExpirationDate(
//                expiresIn: response.refreshTokenExpiresIn
//            )
//        ]
//        
//        for data in responseData {
//            keyChainService.save(data.value, forKey: data.key)
//        }
//    }
//    
//    private func saveProvider(_ provider: Provider) {
//        let lastLogin = LastLogin(provider: provider.rawValue, timestamp: Date())
//        
//        let _ = userDefaultsService.save(provider.rawValue, key: .provider)
//        let _ = userDefaultsService.save(lastLogin, key: .lastProvider)
//    }
//    
//    private var isTokenExists: Bool {
//        if let accessToken = keyChainService.load(key: .accessToken),
//           let refreshToken = keyChainService.load(key: .refreshToken),
//           !accessToken.isEmpty,
//           !refreshToken.isEmpty {
//            return true
//        }
//        return false
//    }
//    
//    private func isAgreedTerms(accessToken: String) async throws -> Bool {
//        do {
//            let _ = try await networkService.request(
//                endPoint: TermsAPI.getTerms(accessToken: accessToken),
//                responseType: TermsResponseDTO.self
//            )
//            return true
//        } catch {
//            return false
//        }
//    }
//    
//    private func deleteUserInformation() {
//        for key in KeyChainKey.allCases {
//            keyChainService.delete(key: key)
//        }
//        let _ = userDefaultsService.delete(key: .provider)
//    }
}
