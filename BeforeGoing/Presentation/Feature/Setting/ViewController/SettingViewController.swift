//
//  SettingViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 7/24/25.
//

import UIKit

final class SettingViewController: BaseViewController, NetworkRequestable {
    
    private let rootView = SettingView()
    private let viewModel: SettingViewModel
    
    private var hasOpenedSettings = false
    
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
                if error == .loginExpired {
                    self.presentLoginExpired()
                }
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
            action: #selector(supportButtonDidTap),
            for: .touchUpInside
        )
        rootView.settingNoticeView.basicPushNoticeView.switchButton.addTarget(
            self,
            action: #selector(pushNoticeButtonDidTap),
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
    private func supportButtonDidTap() {
        ExternalLink.support.openURL(for: self)
    }
    
    @objc
    private func pushNoticeButtonDidTap() {
        let isSwitchedOn = rootView.isSwitchedOn
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async { [weak self] in
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    self?.performTask(isSwitchedOn: isSwitchedOn)
                case .denied, .notDetermined:
                    self?.hasOpenedSettings = true
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                @unknown default:
                    break
                }
            }
        }
    }
    
    func pushNoticeDidBecomeActive() {
        guard hasOpenedSettings else { return }
        hasOpenedSettings = false
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    self.rootView.toggleSwitch()
                    self.performTask(isSwitchedOn: true)
                }
            }
        }
    }
    
    private func performTask(isSwitchedOn: Bool) {
        Task {
            do {
                let _ = try await viewModel.action(input: .switchButtonDidTap(isSwitchedOn))
            } catch {
                if let error = error as? BeforeGoingError,
                   error == .loginExpired {
                    self.presentLoginExpired()
                }
            }
        }
    }
    
    @objc
    private func termButtonDidTap() {
        ExternalLink.term.openURL(for: self)
    }
    
    @objc
    private func privacyButtonDidTap() {
        ExternalLink.privacy.openURL(for: self)
    }
}
