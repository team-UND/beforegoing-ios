//
//  LogoutUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/13/25.
//

struct LogoutUseCase {
    
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.logout()
    }
}
