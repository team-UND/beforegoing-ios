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
                let output = try await viewModel.action(input: .viewDidLoad)
                
                switch output {
                case .autoLogin(let isSucceedAutoLogin):
                    isSucceedAutoLogin ? moveHome() : moveLogin()
                }
            } catch {
                BeforeGoingLogger.error(BeforeGoingError.autoLoginFailed)
                moveLogin()
            }
        }
    }
    
    private func moveHome() {
        let viewController = BottomNavigationViewController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ViewControllerUtil.replaceRootViewController(to: viewController)
        }
    }
    
    private func moveLogin() {
        let viewController = ViewControllerFactory.shared.makeLoginViewController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            viewController.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
