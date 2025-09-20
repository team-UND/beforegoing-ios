//
//  SendNonceUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 7/22/25.
//

struct KakaoLoginUseCase {
    
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute(provider: String) async throws {
        let nonce = try await requestNonce(provider: provider)
        let idToken = try await repository.requestIDToken(nonce: nonce)
        try await requestKakaoLogin(provider: provider, idToken: idToken)        
    }
    
    private func requestNonce(provider: String) async throws -> String {
        let nonceEntity = try await repository.requestNonce(provider: provider)
        return nonceEntity.nonce
    }
    
    private func requestKakaoLogin(provider: String, idToken: String) async throws {
        try await repository.requestKakaoLogin(provider: provider, idToken: idToken)
    }
}
