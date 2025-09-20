//
//  SplashViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/12/25.
//

final class SplashViewModel: ViewModeling {
    
    private let useCase: AutoLoginType
    
    init(useCase: AutoLoginType) {
        self.useCase = useCase
    }
    
    enum Input {
        case viewDidLoad
    }

    enum Output {
        case autoLogin(Bool)
    }

    func action(input: Input) async throws -> Output {
        switch input {
        case .viewDidLoad:
            let isSucceedAutoLogin = try await useCase.execute()
            return .autoLogin(isSucceedAutoLogin)
        }
    }
}
