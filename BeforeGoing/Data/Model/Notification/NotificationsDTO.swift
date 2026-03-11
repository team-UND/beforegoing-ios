//
//  NotificationsDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 12/3/25.
//

struct NotificationsDTO: Decodable {
    let scenarios: [ScenarioNotificationDTO]
}

struct ScenarioNotificationDTO: Decodable {
    let scenarioId: Int
    let scenarioName: String
    let memo: String
    let notificationId: Int
    let notificationType: String
    let notificationMethodType: String
    let daysOfWeekOrdinal: [Int]
    let notificationCondition: NotificationConditionDTO
}

extension NotificationsDTO {
    func toEntity() -> NotificationsEntity {
        let scenarios = scenarios.map { $0.toEntity() }
        return .init(notifications: scenarios)
    }
}

extension ScenarioNotificationDTO {
    func toEntity() -> NotificationEntity {
        .init(
            scenarioID: scenarioId,
            scenarioName: scenarioName,
            memo: memo,
            notificationID: notificationId,
            notificationType: notificationType,
            notificationMethodType: notificationMethodType,
            daysOfWeekOrdinal: daysOfWeekOrdinal,
            notificationCondition: notificationCondition.toEntity()
        )
    }
}
