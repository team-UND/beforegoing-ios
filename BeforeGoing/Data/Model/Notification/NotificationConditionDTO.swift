//
//  NotificationConditionDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

struct NotificationConditionDTO: Codable {
    let notificationType: String
    let startHour: Int
    let startMinute: Int
}

extension NotificationConditionDTO {
    
    func toEntity() -> NotificationConditionEntity {
        return .init(
            notificationType: notificationType,
            startHour: startHour,
            startMinute: startMinute
        )
    }
}
