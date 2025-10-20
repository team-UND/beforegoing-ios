//
//  OnboardingViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/6/25.
//

import UIKit

final class OnboardingViewController: BaseViewController {
    
    private let rootView = OnboardingView(step: .first)
    
    override func loadView() {
        view = rootView
    }
    
    override func setView() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setAction() {
        rootView.bottomButton.addTarget(
            self,
            action: #selector(bottomButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension OnboardingViewController {
    
    @objc
    private func bottomButtonDidTap() {
        let updateResult = rootView.updateUI()
        if !updateResult {
            let viewController = ViewControllerFactory.shared.makeAlarmAuthorizationViewController()
            viewController.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
}
