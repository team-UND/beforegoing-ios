//
//  NotificationnManager.swift
//  BeforeGoing
//
//  Created by APPLE on 10/6/25.
//

import UserNotifications

final class NotificationManager {
    
    static let shared = NotificationManager()
    private init() {}
    
    func setPermission() {
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
    }
    
    func pushDailyNotification(
        title: String,
        body: String,
        daysOfWeek: [Int],
        date: Date,
        identifier: String
    ) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: daysOfWeek.map { _ in "\(identifier)" }
        )
        
        let notificationContent = createNotificationContent(title: title, body: body)
        
        for day in daysOfWeek {
            let triggerComponents = createTriggerComponents(date: date, day: day)
            let trigger = createCalendarTrigger(components: triggerComponents)
            
            let request = createNotificationRequest(
                identifier: identifier,
                notificationContent: notificationContent,
                trigger: trigger
            )
            
            addRequest(request)
        }
    }
    
    func removeDeliveredNotification(identifiers: [String]){
        UNUserNotificationCenter
            .current()
            .removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    
    private func createNotificationContent(title: String, body: String) -> UNMutableNotificationContent {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        
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
    
    private func createNotificationRequest(
        identifier: String,
        notificationContent: UNMutableNotificationContent,
        trigger: UNCalendarNotificationTrigger
    ) -> UNNotificationRequest {
        UNNotificationRequest(identifier: identifier,
                              content: notificationContent,
                              trigger: trigger)
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
