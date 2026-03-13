//
//  AppleLoginUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/21/25.
//

protocol LoginType {
    func execute() async throws -> Bool
}

struct LoginUseCase: LoginType {
    
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> Bool {
        try await repository.login()
    }
}

struct MockLoginUseCase: LoginType {
    func execute() -> Bool {
        return true
    }
}
