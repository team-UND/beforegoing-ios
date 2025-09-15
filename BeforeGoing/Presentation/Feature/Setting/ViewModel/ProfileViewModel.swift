//
//  ProfileViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/13/25.
//

final class ProfileViewModel: ViewModeling {
    
    private let logoutUseCase: LogoutUseCase
    
    init(logoutUseCase: LogoutUseCase) {
        self.logoutUseCase = logoutUseCase
    }
    
    enum Input {
        case logoutButtonDidTap
        case withdrawButtonDidTap
    }

    enum Output {
        case logout
        case withdraw
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .logoutButtonDidTap:
            try await logoutUseCase.execute()
            return .logout
        case .withdrawButtonDidTap:
            return .withdraw
        }
    }
}
