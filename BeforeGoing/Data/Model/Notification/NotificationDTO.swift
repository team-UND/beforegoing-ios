//
//  NotificationDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

protocol NotificationDTO: Codable {}

struct ActiveNotificationDTO: NotificationDTO {
    var isActive: Bool = true
    let notificationType: String
    let notificationMethodType: String
    let daysOfWeekOrdinal: [Int]
}

struct InactiveNotificationDTO: NotificationDTO {
    var isActive: Bool = false
    let notificationType: String
}
