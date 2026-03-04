//
//  NotificationsEntity.swift
//  BeforeGoing
//
//  Created by APPLE on 12/3/25.
//

struct NotificationsEntity {
    let notifications: [NotificationEntity]
}

struct NotificationEntity {
    let scenarioID: Int
    let scenarioName: String
    let memo: String
    let notificationID: Int
    let notificationType: String
    let notificationMethodType: String
    let daysOfWeekOrdinal: [Int]
    let notificationCondition: NotificationConditionEntity
}

extension NotificationsEntity {
    static func stub() -> Self {
        .init(notifications: [.stub()])
    }
}

extension NotificationEntity {
    static func stub() -> Self {
        .init(
            scenarioID: 1,
            scenarioName: "시나리오",
            memo: "메모",
            notificationID: 1,
            notificationType: "TIME",
            notificationMethodType: "PUSH",
            daysOfWeekOrdinal: [0,2,4],
            notificationCondition: .stub()
        )
    }
}
