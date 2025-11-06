//
//  NotificationnManager.swift
//  BeforeGoing
//
//  Created by APPLE on 10/6/25.
//

import UserNotifications

final class NotificationManager {
    
    static let shared = NotificationManager()
    private let terminateIdentifier = "terminate"
    
    private init() {}
    
    func setPermission(completion: @escaping () -> Void) {
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func pushDailyNotification(
        title: String,
        body: String,
        daysOfWeek: [Int],
        date: Date,
        identifier: String
    ) {
        let identifiersToRemove = (0...6).map { "\(identifier)_\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
        
        let notificationContent = createNotificationContent(
            title: title,
            body: body,
            identifier: identifier,
            sound: UNNotificationSound.default
        )
        
        for day in daysOfWeek {
            let requestIdentifier = "\(identifier)_\(day)"
            let triggerComponents = createTriggerComponents(date: date, day: day)
            let trigger = createCalendarTrigger(components: triggerComponents)
            let request = createNotificationRequest(
                identifier: requestIdentifier,
                notificationContent: notificationContent,
                trigger: trigger
            )
            
            addRequest(request)
        }
    }
    
    func reserveSnooze(
        originalContent: UNNotificationContent,
        identifier: String,
        delayMinutes: Double
    ) {
        guard let notificationIdentifier = NotificationIdentifier.convertIdentifier(from: identifier),
              let callNoticeIdentifier = notificationIdentifier.nextCallNotice(text: identifier) else {
            return
        }
        
        let newContent = originalContent.mutableCopy() as! UNMutableNotificationContent
        let timeInterval = delayMinutes * 60.0
        let trigger = createIntervalTrigger(timeInterval: timeInterval)
        let request = createNotificationRequest(
            identifier: callNoticeIdentifier,
            notificationContent: newContent,
            trigger: trigger
        )
        
        addRequest(request)
    }
    
    func removeDeliveredNotification(identifiers: [String]){
        UNUserNotificationCenter
            .current()
            .removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    
    func pushTerminateNotification() async {
        let pendingRequests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        
        if pendingRequests.count > 0 {
            let request = createNotificationRequest(
                identifier: terminateIdentifier,
                notificationContent: createNotificationContent(
                    title: "잠시만요!",
                    body: "앱을 완전히 종료하면 설정한 알람이 울리지 않아요",
                    identifier: terminateIdentifier
                )
            )
            addRequest(request)
        }
    }
    
    private func createNotificationContent(
        title: String,
        body: String,
        identifier: String
    ) -> UNMutableNotificationContent {
        let notificationContent: UNMutableNotificationContent = {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.userInfo["identifier"] = identifier
            return content
        }()
        
        return notificationContent
    }
    
    private func createNotificationContent(
        title: String,
        body: String,
        identifier: String,
        sound: UNNotificationSound
    ) -> UNMutableNotificationContent {
        let notificationContent: UNMutableNotificationContent = {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.userInfo["identifier"] = identifier
            content.sound = sound
            return content
        }()
        
        return notificationContent
    }
    
    private func createTriggerComponents(date: Date, day: Int) -> DateComponents {
        var dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        dateComponents.weekday = convertWeekDay(from: day)
        return dateComponents
    }
    
    private func createCalendarTrigger(components: DateComponents) -> UNCalendarNotificationTrigger {
        UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
    }
    
    private func createIntervalTrigger(timeInterval: TimeInterval) -> UNTimeIntervalNotificationTrigger {
        UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
    }
    
    private func createNotificationRequest(
        identifier: String,
        notificationContent: UNMutableNotificationContent,
        trigger: UNCalendarNotificationTrigger
    ) -> UNNotificationRequest {
        UNNotificationRequest(identifier: identifier,
                              content: notificationContent,
                              trigger: trigger)
    }
    
    private func createNotificationRequest(
        identifier: String,
        notificationContent: UNMutableNotificationContent,
        trigger: UNTimeIntervalNotificationTrigger
    ) -> UNNotificationRequest {
        UNNotificationRequest(identifier: identifier,
                              content: notificationContent,
                              trigger: trigger)
    }
    
    private func createNotificationRequest(
        identifier: String,
        notificationContent: UNMutableNotificationContent
    ) -> UNNotificationRequest {
        UNNotificationRequest(identifier: identifier,
                              content: notificationContent,
                              trigger: nil)
    }
    
    private func addRequest(_ request: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    private func convertWeekDay(from day: Int) -> Int {
        if day + 2 > 7 {
            return (day + 2) % 7
        }
        return day + 2
    }
}
