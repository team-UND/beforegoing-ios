//
//  LogoutUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/13/25.
//

protocol LogoutType {
    func execute() async throws
}

struct LogoutUseCase: LogoutType {
    
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.logout()
    }
}

struct MockLogoutUseCase: LogoutType {
    
    func execute() {}
}
