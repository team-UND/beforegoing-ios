//
//  SettingViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 7/24/25.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    private let rootView = SettingView()
    
    override func loadView() {
        view = rootView
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
