//
//  NotificationConditionEntity.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

struct NotificationConditionEntity {
    let notificationType: String
    let startHour: Int
    let startMinute: Int
}

extension NotificationConditionEntity {
    
    static func stub() -> Self {
        return .init(
            notificationType: "TIME",
            startHour: 12,
            startMinute: 50
        )
    }
}
