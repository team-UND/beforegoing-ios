//
//  LoginViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

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
                let output = try await viewModel.action(input: .kakaoLoginDidTap)
                output.result ? moveHome() : moveTerms()
            } catch(let error) {
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    @objc
    func appleLoginButtonDidTap() {
        print("Apple Did Tap")
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
