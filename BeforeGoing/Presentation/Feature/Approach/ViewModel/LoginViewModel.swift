//
//  LoginViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/10/25.
//

final class LoginViewModel: ViewModeling {
    
    private let loginUseCase: LoginType
    
    init(loginUseCase: LoginType) {
        self.loginUseCase = loginUseCase
    }
    
    enum Input {
        case viewDidLoad
    }
    
    typealias Output = LoginOutput
    
    struct LoginOutput {
        let isRegisteredMember: Bool
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .viewDidLoad:
            let isRegisteredMember = try await loginUseCase.execute()
            return LoginOutput(isRegisteredMember: isRegisteredMember)
        }
    }
}
