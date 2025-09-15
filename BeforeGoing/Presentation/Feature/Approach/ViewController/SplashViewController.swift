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
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let viewController = ViewControllerFactory.shared.makeLoginViewController()
            viewController.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        // 추후 주석 제거 예정
//        Task {
//            do {
//                var viewController: UIViewController
//                let output = try await viewModel.action(input: .viewDidLoad)
//                
//                switch output {
//                case .autoLogin(let isSucceedAutoLogin):
//                    if isSucceedAutoLogin {
//                        viewController = BottomNavigationViewController()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            ViewControllerUtil.shared.replaceRootViewController(to: viewController)
//                        }
//                    } else {
//                        viewController = ViewControllerFactory.shared.makeLoginViewController()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            viewController.navigationItem.hidesBackButton = true
//                            self.navigationController?.pushViewController(viewController, animated: true)
//                        }
//                    }
//                }
//            } catch {
//                BeforeGoingLogger.error(BeforeGoingError.autoLoginFailed)
//            }
//        }
    }
}
