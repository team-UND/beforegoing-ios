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
    
    init(networkService: NetworkService, tokenReissuer: TokenReissuer, keyChainService: KeyChainService) {
        self.networkService = networkService
        self.tokenReissuer = tokenReissuer
        self.keyChainService = keyChainService
    }
    
    func requestNonce(dto: NonceRequestDTO) async throws -> NonceEntity {
        let response = try await networkService.request(
            endPoint: AuthAPI.nonce(dto: dto),
            responseType: NonceResponseDTO.self
        )
        return response.toEntity()
    }
    
    func requestIDToken(nonce: String?) async throws -> String {
        return try await networkService.requestKakaoIDToken(nonce: nonce)
    }
    
    func requestKakaoLogin(dto: LoginRequestDTO) async throws {
        let response = try await networkService.request(
            endPoint: AuthAPI.kakaoLogin(dto: dto),
            responseType: LoginResponseDTO.self
        )
        // 기존 가입 여부에 따른 분기 처리
        saveKeyChain(response: response)
    }
    
    private func saveKeyChain(response: LoginResponseDTO) {
        keyChainService.save(response.accessToken, forKey: KeyChainKey.accessToken.rawValue)
        keyChainService.save(response.refreshToken, forKey: KeyChainKey.refreshToken.rawValue)
    }
    
    func autoLogin() async throws -> Bool {
        guard let accessToken = keyChainService.load(key: KeyChainKey.accessToken.rawValue),
              let refreshToken = keyChainService.load(key: KeyChainKey.refreshToken.rawValue),
              !accessToken.isEmpty,
              !refreshToken.isEmpty else {
            
            return false
        }
        try await tokenReissuer.reissue()
        return true
    }
}
