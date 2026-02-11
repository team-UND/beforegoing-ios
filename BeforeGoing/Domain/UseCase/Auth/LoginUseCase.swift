//
//  AppleLoginUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/21/25.
//

protocol LoginType {
    func execute() -> Bool
}

struct LoginUseCase: LoginType {
    
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute() -> Bool {
        repository.login()
    }
}

struct MockLoginUseCase: LoginType {
    func execute() -> Bool {
        return true
    }
}
