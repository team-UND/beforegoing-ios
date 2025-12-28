//
//  SettingViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 7/24/25.
//

import CoreLocation
import UIKit

final class SettingViewController: BaseViewController {
    
    private let rootView = SettingView()
    private let locationManager = CLLocationManager()
    private let viewModel: SettingViewModel
    
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkPushNoticeAuthorization),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkLocationAuthorization),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkPushNoticeAuthorization()
        checkLocationAuthorization()
        checkEventPush()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func setAction() {
        rootView.accountView.seemoreView.addGestureRecognizer(createTapGesture(action: #selector(profileButtonDidTap)))
        rootView.accountView.seemoreView.moveButton.addTarget(
            self,
            action: #selector(profileButtonDidTap),
            for: .touchUpInside
        )
        
        rootView.supportView.seemoreView.addGestureRecognizer(createTapGesture(action: #selector(supportButtonDidTap)))
        rootView.supportView.seemoreView.moveButton.addTarget(
            self,
            action: #selector(supportButtonDidTap),
            for: .touchUpInside
        )
        
        rootView.settingNoticeView.locationAuthorizationView.switchButton.addTarget(
            self,
            action: #selector(authorizationSwitchChanged(_:)),
            for: .valueChanged
        )
        rootView.settingNoticeView.basicPushNoticeView.switchButton.addTarget(
            self,
            action: #selector(authorizationSwitchChanged(_:)),
            for: .valueChanged
        )
        rootView.settingNoticeView.eventPushNoticeView.switchButton.addTarget(
            self,
            action: #selector(eventPushNoticeButtonDidTap),
            for: .touchUpInside
        )
        
        rootView.policyView.noticeView.addGestureRecognizer(createTapGesture(action: #selector(noticeButtonDidTap)))
        rootView.policyView.noticeView.moveButton.addTarget(
            self,
            action: #selector(noticeButtonDidTap),
            for: .touchUpInside
        )
        rootView.policyView.termView.addGestureRecognizer(createTapGesture(action: #selector(termButtonDidTap)))
        rootView.policyView.termView.moveButton.addTarget(
            self,
            action: #selector(termButtonDidTap),
            for: .touchUpInside
        )
        rootView.policyView.privacyView.addGestureRecognizer(createTapGesture(action: #selector(privacyButtonDidTap)))
        rootView.policyView.privacyView.moveButton.addTarget(
            self,
            action: #selector(privacyButtonDidTap),
            for: .touchUpInside
        )
    }
    
    private func createTapGesture(action: Selector) -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: action
        )
        return tapGesture
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
        alertEventPushChange(isSwitchedOn: isSwitchedOn)
    }
    
    @objc
    private func authorizationSwitchChanged(_ sender: UISwitch) {
        let isAgreed = sender.isOn
        sender.setOn(isAgreed, animated: true)
        
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc
    func checkPushNoticeAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async { [weak self] in
                var isAgreed = false
                
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    isAgreed = (settings.alertSetting == .enabled)
                case .denied:
                    break
                case .notDetermined:
                    self?.requestAuthorization()
                    return
                @unknown default:
                    break
                }
                
                self?.rootView.settingNoticeView.basicPushNoticeView.updateSwitch(isAgreed: isAgreed)
            }
        }
    }
    
    @objc
    func checkLocationAuthorization() {
        var isAgreed = false
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAgreed = true
        case .denied, .restricted:
            break
        case .notDetermined:
            locationManager.do {
                $0.delegate = self
                $0.requestAlwaysAuthorization()
            }
            return
        @unknown default:
            break
        }
        
        rootView.settingNoticeView.locationAuthorizationView.updateSwitch(isAgreed: isAgreed)
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
    
    private func checkEventPush() {
        Task {
            guard let result = try await viewModel.action(
                input: .viewWillAppear
            ) as? SettingViewModel.EventPushAgreedOutput else {
                return
            }
            
            switch result.isEventPushAgreed {
            case .success(let eventPushAgreed):
                rootView.settingNoticeView.eventPushNoticeView.updateSwitch(isAgreed: eventPushAgreed)
            case .failure(let error):
                self.handleError(error)
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    private func alertEventPushChange(isSwitchedOn: Bool) {
        let isReception = isSwitchedOn ? "수신 동의" : "수신 거부"
        let currentDate = DateUtil.getCurrentDate(format: "yyyy년 MM월 dd일")
        
        Task {
            do {
                let _ = try await viewModel.action(input: .switchButtonDidTap(isSwitchedOn))
                let alert = UIAlertController(
                    title: "",
                    message: "[나가기전에]에서 보내는 이벤트/마케팅 관련\n푸시알림 수신 여부가\n '\(isReception)'로 변경되었습니다.\n\(currentDate)",
                    preferredStyle: .alert
                )
                let success = UIAlertAction(title: "확인", style: .default)
                alert.addAction(success)
                present(alert, animated: true, completion: nil)
            } catch {
                self.handleError(error)
            }
        }
    }
    
    private func requestAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in
            DispatchQueue.main.async { [weak self] in
                self?.checkPushNoticeAuthorization()
            }
        }
    }
}

extension SettingViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
