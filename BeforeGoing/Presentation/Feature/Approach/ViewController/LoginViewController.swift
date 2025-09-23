//
//  LoginViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import AuthenticationServices
import UIKit

final class LoginViewController: BaseViewController {
    
    private let rootView = LoginView()
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func setAction() {
        rootView.do {
            $0.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonDidTap), for: .touchUpInside)
            $0.appleLoginButton.addTarget(self, action: #selector(appleLoginButtonDidTap), for: .touchUpInside)
        }
    }
}

extension LoginViewController {
    
    @objc
    func kakaoLoginButtonDidTap() {
        Task {
            do {
                guard let output = try await viewModel.action(
                    input: .kakaoLoginDidTap
                ) as? LoginViewModel.SocialLoginOutput else {
                    return
                }
                output.isRegisteredMember ? moveHome() : moveTerms()
            } catch(let error) {
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    @objc
    func appleLoginButtonDidTap() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        
        Task {
            do {
                guard let result = try await viewModel.action(
                    input: .appleLoginDidTap
                ) as? LoginViewModel.NonceOutput else {
                    return
                }
                request.nonce = result.nonce
                
                let controller = ASAuthorizationController(authorizationRequests: [request])
                controller.do {
                    $0.delegate = self
                    $0.presentationContextProvider = self
                    $0.performRequests()
                }
            } catch (let error) {
                BeforeGoingLogger.error(error)
                BeforeGoingLogger.error(BeforeGoingError.loginFailed)
            }
        }
    }
    
    private func moveHome() {
        let viewController = BottomNavigationViewController()
        ViewControllerUtil.shared.replaceRootViewController(to: viewController)
    }
    
    private func moveTerms() {
        let viewController = ViewControllerFactory.shared.makeAgreeTermsViewController()
        viewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController (
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityTokenData = credential.identityToken else {
             return
        }
        
        let idToken = String(data: identityTokenData, encoding: .utf8) ?? ""
        Task {
            do {
                guard let output = try await viewModel.action(
                    input: .requestAppleLogin(idToken: idToken)
                ) as? LoginViewModel.SocialLoginOutput else {
                    return
                }
                output.isRegisteredMember ? moveHome() : moveTerms()
            } catch (let error) {
                BeforeGoingLogger.error(error)
                BeforeGoingLogger.error(BeforeGoingError.loginFailed)
            }
        }
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
}
