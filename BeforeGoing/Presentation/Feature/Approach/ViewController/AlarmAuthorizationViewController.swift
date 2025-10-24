//
//  AlarmAuthorizationViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 10/20/25.
//

import Foundation

final class AlarmAuthorizationViewController: BaseViewController {
    
    private let rootView = AlarmAuthorizationView()
    
    override func loadView() {
        view = rootView
    }
    
    override func setAction() {
        rootView.agreeButton.addTarget(
            self,
            action: #selector(agreeButtonDidTap),
            for: .touchUpInside
        )
        rootView.disagreeButton.addTarget(
            self,
            action: #selector(disagreeButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension AlarmAuthorizationViewController {
    
    @objc
    private func agreeButtonDidTap() {
        NotificationManager.shared.setPermission { [weak self] in
            self?.moveLocationAuthorization()
        }
    }
    
    @objc
    private func disagreeButtonDidTap() {
        moveLocationAuthorization()
    }
    
    private func moveLocationAuthorization() {
        let viewController = ViewControllerFactory.shared.makeLocationAuthorizationViewController()
        viewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(viewController, animated: false)
    }
}
