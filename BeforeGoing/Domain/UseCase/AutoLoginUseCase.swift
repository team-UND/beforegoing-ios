//
//  AutoLoginUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/12/25.
//

protocol AutoLoginType {
    func execute() async throws -> Bool
}

struct AutoLoginUseCase: AutoLoginType {
    
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> Bool {
        return try await repository.autoLogin()
    }
}

struct MockAutoLoginUseCase: AutoLoginType {
    func execute() -> Bool {
        return true
    }
}
