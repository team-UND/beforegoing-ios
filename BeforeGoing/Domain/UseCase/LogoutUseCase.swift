//
//  LogoutUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/13/25.
//

struct LogoutUseCase {
    
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.logout()
    }
}
