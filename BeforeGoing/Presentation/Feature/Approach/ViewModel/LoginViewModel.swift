//
//  LoginViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/10/25.
//

protocol LoginOutput {}

import AuthenticationServices

final class LoginViewModel: NSObject, ViewModeling {
    
    private let autoLoginUseCase: AutoLoginType
    private let loginUseCase: LoginType
    private let getLastLoginUseCase: GetLastLoginType
    
    var onAppleLoginPerformed: ((Bool) -> Void)?
    
    init(
        autoLoginUseCase: AutoLoginType,
        loginUseCase: LoginType,
        getLastLoginUseCase: GetLastLoginType
    ) {
        self.autoLoginUseCase = autoLoginUseCase
        self.loginUseCase = loginUseCase
        self.getLastLoginUseCase = getLastLoginUseCase
    }
    
    enum Input {
        case viewWillAppear
        case viewDidLoad
        case kakaoLoginDidTap
        case appleLoginDidTap
    }
    
    typealias Output = LoginOutput
    
    struct AutoLoginOutput: LoginOutput {
        let isSucceed: Bool
    }
    
    struct SocialLoginOutput: LoginOutput  {
        let isRegisteredMember: Bool
    }
    
    struct LastLoginOutput: LoginOutput {
        let lastLoginProvider: Provider?
    }
    
    struct EmptyOutput: LoginOutput {}
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .viewWillAppear:
            let provider = getLastLoginUseCase.execute()
            return LastLoginOutput(lastLoginProvider: provider)
            
        case .viewDidLoad:
            let isSucceedAutoLogin = try await autoLoginUseCase.execute()
            return AutoLoginOutput(isSucceed: isSucceedAutoLogin)
            
        case .kakaoLoginDidTap:
            let isRegisteredMember = try await loginUseCase.login(provider: .kakao)
            return SocialLoginOutput(isRegisteredMember: isRegisteredMember)
            
        case .appleLoginDidTap:
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            
            let nonce = try await loginUseCase.requestNonce(provider: .apple)
            request.nonce = nonce
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.do {
                $0.delegate = self
                $0.presentationContextProvider = self
                $0.performRequests()
            }
            
            return EmptyOutput()
        }
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    
    func authorizationController (
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityTokenData = credential.identityToken,
              let idToken = String(data: identityTokenData, encoding: .utf8) else {
             return
        }
        
        Task {
            do {
                let isMemberRegistered = try await loginUseCase.login(provider: .apple, idToken: idToken)
                onAppleLoginPerformed?(isMemberRegistered)
            } catch (let error) {
                BeforeGoingLogger.error(error)
                BeforeGoingLogger.error(BeforeGoingError.loginFailed)
            }
        }
    }
}

extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        ViewControllerUtil.findTopWindow()
    }
}
