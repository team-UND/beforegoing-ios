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
    
    private var hasOpenedSettings = false
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return
        }
        rootView.configure(version: version)
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
                rootView.settingNoticeView.eventPushNoticeView.updateButtonState(condition: eventPushAgreed)
            case .failure(let error):
                self.handleError(error)
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
        rootView.settingNoticeView.eventPushNoticeView.switchButton.addTarget(
            self,
            action: #selector(eventPushNoticeButtonDidTap),
            for: .touchUpInside
        )
        rootView.settingNoticeView.basicPushNoticeView.switchButton.addTarget(
            self,
            action: #selector(pushNoticeButtonDidTap),
            for: .touchUpInside
        )
        rootView.policyView.noticeView.moveButton.addTarget(
            self,
            action: #selector(noticeButtonDidTap),
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

extension SettingViewController: NetworkRequestable, NetworkRequestErrorHandler {
    
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
    private func eventPushNoticeButtonDidTap() {
        let isSwitchedOn = rootView.settingNoticeView.eventPushNoticeView.switchButton.isOn
        performTask(isSwitchedOn: isSwitchedOn)
    }
    
    @objc
    private func pushNoticeButtonDidTap() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async { [weak self] in
                self?.hasOpenedSettings = true
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    func pushNoticeDidBecomeActive() {
        guard hasOpenedSettings else { return }
        hasOpenedSettings = false
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                let isAgreed: Bool

                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    isAgreed = true
                case .denied, .notDetermined:
                    isAgreed = false
                @unknown default:
                    isAgreed = false
                }
                
                let currentDate = DateUtil.getCurrentDate().toString()
                let modalVC = ModalViewController(
                    modalView: ModalView(type: .eventPushAgree(isAgreed: isAgreed, currentDate: currentDate))
                )
                
                self.rootView.updateSwitch(isAgreed: isAgreed)
                self.present(modalVC, animated: true)
            }
        }
    }
    
    private func performTask(isSwitchedOn: Bool) {
        Task {
            do {
                let _ = try await viewModel.action(input: .switchButtonDidTap(isSwitchedOn))
            } catch {
                self.handleError(error)
            }
        }
    }
    
    @objc
    private func noticeButtonDidTap() {
        ExternalLink.notice.openURL(for: self)
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
