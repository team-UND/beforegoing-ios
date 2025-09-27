//
//  NotificationDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

enum NotificationDTO: Encodable {
    case active(ActiveNotificationDTO)
    case inactive(InactiveNotificationDTO)
}

struct ActiveNotificationDTO: Encodable {
    var isActive: Bool = true
    let notificationType: String
    let notificationMethodType: String
    let daysOfWeekOrdinal: [Int]
}

struct InactiveNotificationDTO: Encodable {
    var isActive: Bool = false
    let notificationType: String
}
