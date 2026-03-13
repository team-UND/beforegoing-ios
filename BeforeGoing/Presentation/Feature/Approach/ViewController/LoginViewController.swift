//
//  LoginViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

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
            let loginOutput = try await viewModel.action(input: .viewDidLoad)
            if loginOutput.isRegisteredMember {
                moveByNotification()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAnimation()
    }
    
    override func setAction() {
        rootView.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
    }
    
    private func setAnimation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 1.5, options: [.curveEaseOut]) {
                self.rootView.do {
                    $0.startButton.alpha = 1
                    $0.layoutIfNeeded()
                }
            }
        }
    }
}

extension LoginViewController: NetworkRequestable, NetworkRequestErrorHandler {
    
    @objc
    func startButtonDidTap() {
        moveTerms()
    }
    
    private func moveByNotification() {
        if let request = AuthManager.shared.pendingNotificationRequest {
            AuthManager.shared.pendingNotificationRequest = nil
            
            guard let notificationIdentifier = NotificationIdentifier.convertIdentifier(from: request.identifier) else {
                return
            }
            
            switch notificationIdentifier {
            case .pushNotice :
                replaceViewController(
                    to: BottomNavigationViewController(
                        scenarioTitle: request.content.title
                    )
                )
            case .callNotice(let sequence):
                replaceViewController(
                    to: NotificationViewController(
                        notificationViewType: .init(sequence: sequence),
                        content: request.content,
                        identifier: notificationIdentifier.identifier
                    )
                )
            case .terminate:
                replaceViewController(to: BottomNavigationViewController())
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
    
    private func replaceViewController(to viewController: UIViewController) {
        ViewControllerUtil.replaceRootViewController(to: viewController)
    }
}
