//
//  SplashViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import UIKit

final class SplashViewController: BaseViewController {
    
    private let rootView = SplashView()
    private let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
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
                var viewController: UIViewController
                let output = try await viewModel.action(input: .viewDidLoad)
                
                switch output {
                case .autoLogin(let isSucceedAutoLogin):
                    if isSucceedAutoLogin {
                        viewController = BottomNavigationViewController()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            ViewControllerUtil.shared.replaceRootViewController(to: viewController)
                        }
                    } else {
                        viewController = LoginViewController(
                            viewModel: LoginViewModel(
                                kakaoLoginUseCase: KakaoLoginUseCase(
                                    nonceRequestMapper: NonceRequestMapper(),
                                    loginRequestMapper: LoginRequestMapper(),
                                    repository: AuthRepository(
                                        networkService: NetworkService.shared,
                                        tokenReissuer: TokenReissuer(keyChainService: KeyChainService()),
                                        keyChainService: KeyChainService()
                                    )
                                )
                            )
                        )
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            viewController.navigationItem.hidesBackButton = true
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    }
                }
            } catch {
                BeforeGoingLogger.error(BeforeGoingError.autoLoginFailed)
            }
        }
    }
}
