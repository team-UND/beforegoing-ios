//
//  SendNonceUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 7/22/25.
//

struct KakaoLoginUseCase {
    
    private let nonceRequestMapper: NonceRequestMapper
    private let loginRequestMapper: LoginRequestMapper
    private let repository: AuthInterface
    
    init(
        nonceRequestMapper: NonceRequestMapper,
        loginRequestMapper: LoginRequestMapper,
        repository: AuthInterface
    ) {
        self.nonceRequestMapper = nonceRequestMapper
        self.loginRequestMapper = loginRequestMapper
        self.repository = repository
    }
    
    func execute(provider: String) async throws -> LoginEntity {
        let nonce = try await requestNonce(provider: provider)
        let idToken = try await repository.requestIDToken(nonce: nonce)
        let loginEntity = try await requestKakaoLogin(provider: provider, idToken: idToken)
        
        return loginEntity
    }
    
    private func requestNonce(provider: String) async throws -> String {
        let nonceRequest = nonceRequestMapper.map(provider)
        let nonceEntity = try await repository.requestNonce(dto: nonceRequest)
        
        return nonceEntity.nonce
    }
    
    private func requestKakaoLogin(provider: String, idToken: String) async throws -> LoginEntity {
        let loginRequest = loginRequestMapper.map((provider, idToken))
        let loginEntity = try await repository.requestKakaoLogin(dto: loginRequest)
        
        return loginEntity
    }
}
