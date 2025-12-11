//
//  AlarmAuthorizationViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 10/20/25.
//

import Foundation
import UIKit
import UserNotifications

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
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    self?.requestAuthorization()
                case .denied:
                    self?.moveSetting()
                case .authorized, .provisional, .ephemeral:
                    self?.moveLocationAuthorization()
                @unknown default:
                    self?.moveLocationAuthorization()
                }
            }
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
    
    private func requestAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in
            DispatchQueue.main.async { [weak self] in
                self?.moveLocationAuthorization()
            }
        }
    }
    
    private func moveSetting() {
        DispatchQueue.main.async {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url) { [weak self] isOpened in
                    if isOpened {
                        self?.moveLocationAuthorization()
                    }
                }
            }
        }
    }
}
