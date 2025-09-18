//
//  SettingViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 7/24/25.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    private let rootView = SettingView()
    private let viewModel: SettingViewModel
    
    init(viewModel: SettingViewModel) {
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
            guard let result = try await viewModel.action(
                input: .viewWillAppear
            ) as? SettingViewModel.EventPushAgreedOutput else {
                return
            }
            switch result.isEventPushAgreed {
            case .success(let eventPushAgreed):
                rootView.settingNoticeView.basicPushNoticeView.updateButtonState(condition: eventPushAgreed)
            case .failure(let error):
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    override func setAction() {
        rootView.accountView.seemoreView.moveButton.addTarget(
            self,
            action: #selector(profileButtonDidTap),
            for: .touchUpInside
        )
        rootView.supportView.seemoreView.moveButton.addTarget(
            self,
            action: #selector(inqureButtonDidTap),
            for: .touchUpInside
        )
        rootView.settingNoticeView.basicPushNoticeView.switchButton.addTarget(
            self,
            action: #selector(pushNoticeButtonDidTap),
            for: .touchUpInside
        )
        rootView.settingNoticeView.nightPushNoticeView.switchButton.addTarget(
            self,
            action: #selector(nightPushNoticeButtonDidTap),
            for: .touchUpInside
        )
        rootView.policyView.termView.moveButton.addTarget(
            self,
            action: #selector(termButtonDidTap),
            for: .touchUpInside
        )
        rootView.policyView.privacyView.moveButton.addTarget(
            self,
            action: #selector(privacyButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension SettingViewController {
    
    @objc
    private func profileButtonDidTap() {
        let viewController = ViewControllerFactory.shared.makeProfileViewController()
        viewController.navigationItem.hidesBackButton = true
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @objc
    private func inqureButtonDidTap() {
        
    }
    
    @objc
    private func pushNoticeButtonDidTap() {
        let isSwitchedOn = rootView.isSwitchedOn
        
        Task {
            try await viewModel.action(input: .switchButtonDidTap(isSwitchedOn))
        }
    }
    
    @objc
    private func nightPushNoticeButtonDidTap() {
        
    }
    
    @objc
    private func termButtonDidTap() {
        
    }
    
    @objc
    private func privacyButtonDidTap() {
        
    }
}
