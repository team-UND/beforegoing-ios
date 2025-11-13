//
//  OnboardingViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/6/25.
//

import UIKit

final class OnboardingViewController: BaseViewController {
    
    private let rootView = OnboardingView(step: .first)
    private let viewModel: OnboardingViewModel
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let updateResult = rootView.moveFront()
        if !updateResult {
            let result = viewModel.action(input: .startButtonDidTap)
            if result.isCompletedOnboarding {
                let viewController = ViewControllerFactory.shared.makeAlarmAuthorizationViewController()
                viewController.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }
    }
}
