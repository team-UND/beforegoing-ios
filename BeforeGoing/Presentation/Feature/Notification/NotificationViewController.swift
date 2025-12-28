//
//  NotificationViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 10/7/25.
//

import UserNotifications
import UIKit

final class NotificationViewController: BaseViewController {
    
    private let snoozeTimeInMinutes: Double = 5
    private let rootView: NotificationView
    private let content: UNNotificationContent
    private let identifier: String
    
    init(
        notificationViewType: NotificationViewType,
        content: UNNotificationContent,
        identifier: String
    ) {
        self.rootView = NotificationView(
            notificationViewType: notificationViewType,
            title: content.title
        )
        self.content = content
        self.identifier = identifier
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AudioManager.shared.startSound()
    }
    
    override func setAction() {
        rootView.actionButtons.forEach {
            switch $0.value {
            case .turnOff:
                $0.key.addTarget(
                    self,
                    action: #selector(turnOffNotificationDidTap),
                    for: .touchUpInside
                )
            case .again:
                $0.key.addTarget(
                    self,
                    action: #selector(againNotificationDidTap),
                    for: .touchUpInside
                )
            }
        }
    }
}

extension NotificationViewController {
    
    @objc
    private func turnOffNotificationDidTap() {
        AudioManager.shared.stopSound()
        replaceToHome()
    }
    
    @objc
    private func againNotificationDidTap() {
        AudioManager.shared.stopSound()
        replaceToHome()
        NotificationManager.shared.reserveSnooze(
            originalContent: self.content,
            identifier: self.identifier,
            delayMinutes: snoozeTimeInMinutes
        )
    }
    
    private func replaceToHome() {
        let bottomNavigationVC = BottomNavigationViewController(scenarioTitle: content.title)
        ViewControllerUtil.replaceRootViewController(to: bottomNavigationVC)
    }
}
