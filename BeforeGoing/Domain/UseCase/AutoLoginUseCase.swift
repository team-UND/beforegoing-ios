//
//  AutoLoginUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/12/25.
//

struct AutoLoginUseCase {
    
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> Bool {
        return try await repository.autoLogin()
    }
}
