//
//  AppleLoginUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/21/25.
//

protocol LoginType {
    
    func login(provider: Provider) async throws -> Bool
    func login(provider: Provider, idToken: String) async throws -> Bool
    func requestNonce(provider: Provider) async throws -> String
}

struct LoginUseCase: LoginType {
    
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func login(provider: Provider) async throws -> Bool {
        try await repository.requestLogin(provider: provider)
    }
    
    func login(provider: Provider, idToken: String) async throws -> Bool {
        return try await repository.requestLogin(provider: provider, idToken: idToken)
    }
    
    func requestNonce(provider: Provider) async throws -> String {
        let nonceEntity = try await repository.requestNonce(provider: provider)
        return nonceEntity.nonce
    }
}

struct MockLoginUseCase: LoginType {
    func login(provider: Provider) -> Bool {
        return true
    }
    
    func login(provider: Provider, idToken: String) -> Bool {
        return true
    }
    
    func requestNonce(provider: Provider) -> String {
        return "nonce"
    }
}
