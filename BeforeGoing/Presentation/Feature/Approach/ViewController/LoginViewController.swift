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
                try await viewModel.action(input: .kakaoLoginDidTap)
                // 이미 있는 회원이라면 홈
                // 첫 회원가입이라면 약관동의로 이동
                let viewController = AgreeTermsViewController(viewModel: AgreeItemViewModel())
                viewController.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(viewController, animated: true)
            } catch(let error) {
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    @objc
    func appleLoginButtonDidTap() {
        print("Apple Did Tap")
    }
}
