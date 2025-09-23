//
//  LoginViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/10/25.
//

protocol LoginOutput {}

import AuthenticationServices

final class LoginViewModel: ViewModeling {
    
    private let loginUseCase: LoginType
    
    init(loginUseCase: LoginType) {
        self.loginUseCase = loginUseCase
    }
    
    enum Input {
        case kakaoLoginDidTap
        case appleLoginDidTap
        case requestAppleLogin(idToken: String)
    }
    
    typealias Output = LoginOutput
    
    struct SocialLoginOutput: LoginOutput  {
        let isRegisteredMember: Bool
    }
    
    struct NonceOutput: LoginOutput {
        let nonce: String
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .kakaoLoginDidTap:
            let isRegisteredMember = try await loginUseCase.login(provider: .kakao)
            return SocialLoginOutput(isRegisteredMember: isRegisteredMember)
            
        case .appleLoginDidTap:
            let nonce = try await loginUseCase.requestNonce(provider: .apple)
            return NonceOutput(nonce: nonce)
            
        case .requestAppleLogin(let idToken) :
            let isRegisteredMember = try await loginUseCase.login(provider: .apple, idToken: idToken)
            return SocialLoginOutput(isRegisteredMember: isRegisteredMember)
        }
    }
}
