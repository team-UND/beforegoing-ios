//
//  LoginViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import AuthenticationServices
import UIKit

final class LoginViewController: BaseViewController {
    
    private(set) var rootView = LoginView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            do {
                if let output = try await viewModel.action(input: .viewDidLoad) as? LoginViewModel.AutoLoginOutput,
                   output.isSucceed {
                    moveHome()
                }
            } catch {
                BeforeGoingLogger.error(BeforeGoingError.autoLoginFailed)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            guard let output = try await viewModel.action(input: .viewWillAppear) as? LoginViewModel.LastLoginOutput else {
                return
            }
            
            rootView.updateLastLoginBadgeConstraint(provider: output.lastLoginProvider)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAnimation()
    }
    
    override func setAction() {
        rootView.do {
            $0.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonDidTap), for: .touchUpInside)
            $0.appleLoginButton.addTarget(self, action: #selector(appleLoginButtonDidTap), for: .touchUpInside)
        }
    }
    
    private func setAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 1.5, options: [.curveEaseOut]) {
                self.rootView.do {
                    $0.appIconTopConstraint?.update(inset: 230.adjustedH)
                    $0.kakaoLoginTopConstraint?.update(offset: 151.adjustedH)
                    
                    $0.kakaoLoginButton.alpha = 1
                    $0.appleLoginButton.alpha = 1
                    $0.lastLoginBadgeView.alpha = 1
                    $0.layoutIfNeeded()
                }
            }
        }
    }
}

extension LoginViewController: NetworkRequestable, NetworkRequestErrorHandler {
    
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
            } catch (let error) {
                self.handleError(error)
                BeforeGoingLogger.error(BeforeGoingError.loginFailed)
            }
        }
    }
    
    @objc
    func appleLoginButtonDidTap() {
        Task {
            do {
                let _ = try await viewModel.action(input: .appleLoginDidTap)
                viewModel.onAppleLoginPerformed = { [weak self] isMemberRegistered in
                    isMemberRegistered ? self?.moveHome() : self?.moveTerms()
                }
            } catch (let error) {
                self.handleError(error)
                BeforeGoingLogger.error(BeforeGoingError.loginFailed)
            }
        }
    }
    
    private func moveHome() {
        if let request = AuthManager.shared.pendingNotificationRequest {
            AuthManager.shared.pendingNotificationRequest = nil
            
            guard let notificationIdentifier = NotificationIdentifier.convertIdentifier(from: request.identifier) else {
                return
            }
                    
            switch notificationIdentifier {
            case .pushNotice :
                ViewControllerUtil.replaceRootViewController(
                    to: BottomNavigationViewController(scenarioTitle: request.content.title)
                )
                
            case .callNotice(let sequence):
                ViewControllerUtil.replaceRootViewController(
                    to: NotificationViewController(
                        notificationViewType: .init(sequence: sequence),
                        content: request.content,
                        identifier: notificationIdentifier.identifier
                    )
                )
            
            case .terminate:
                ViewControllerUtil.replaceRootViewController(to: BottomNavigationViewController())
            }
            return
        }
        let viewController = BottomNavigationViewController()
        ViewControllerUtil.replaceRootViewController(to: viewController)
    }
    
    private func moveTerms() {
        let viewController = ViewControllerFactory.shared.makeAgreeTermsViewController()
        viewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
