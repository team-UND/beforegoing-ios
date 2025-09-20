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
    private let nonceRequestMapper: NonceRequestMapper
    private let loginRequestMapper: LoginRequestMapper
    
    init(
        networkService: NetworkService,
        tokenReissuer: TokenReissuer,
        keyChainService: KeyChainService,
        nonceRequestMapper: NonceRequestMapper,
        loginRequestMapper: LoginRequestMapper
    ) {
        self.networkService = networkService
        self.tokenReissuer = tokenReissuer
        self.keyChainService = keyChainService
        self.nonceRequestMapper = nonceRequestMapper
        self.loginRequestMapper = loginRequestMapper
    }
    
    func requestNonce(provider: String) async throws -> NonceEntity {
        let nonceRequestDTO = nonceRequestMapper.map(provider)
        let response = try await networkService.request(
            endPoint: AuthAPI.nonce(dto: nonceRequestDTO),
            responseType: NonceResponseDTO.self
        )
        return response.toEntity()
    }
    
    func requestIDToken(nonce: String?) async throws -> String {
        return try await networkService.requestKakaoIDToken(nonce: nonce)
    }
    
    func requestKakaoLogin(provider: String, idToken: String) async throws {
        let requestDTO = loginRequestMapper.map((provider, idToken))
        let response = try await networkService.request(
            endPoint: AuthAPI.kakaoLogin(dto: requestDTO),
            responseType: LoginResponseDTO.self
        )
        // 기존 가입 여부에 따른 분기 처리
        saveKeyChain(response: response)
    }
    
    private func saveKeyChain(response: LoginResponseDTO) {
        keyChainService.save(response.accessToken, forKey: .accessToken)
        keyChainService.save(response.refreshToken, forKey: .refreshToken)
    }
    
    func autoLogin() async throws -> Bool {
        guard let accessToken = keyChainService.load(key: .accessToken),
              let refreshToken = keyChainService.load(key: .refreshToken),
              !accessToken.isEmpty,
              !refreshToken.isEmpty else {
            
            return false
        }
        do {
            try await tokenReissuer.reissue()
            return true
        } catch {
            BeforeGoingLogger.error(BeforeGoingError.reissueTokenFailed)
            return false
        }
    }
    
    func logout() async throws {
        try await networkService.request(endPoint: AuthAPI.logout)
        deleteUserInformation()
    }
    
    func deleteUserInformation() {
        keyChainService.delete(key: .accessToken)
        keyChainService.delete(key: .refreshToken)
    }
}
