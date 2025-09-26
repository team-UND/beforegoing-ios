//
//  AddScenarioRequestDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

enum AddScenarioRequestDTO {
    case withNotification(WithNotificationAddScenarioRequestDTO)
    case withoutNotification(WithoutNotificationAddScenarioRequestDTO)
}

struct WithNotificationAddScenarioRequestDTO: Encodable {
    let scenarioName: String
    let memo: String
    let basicMissions: [BasicMissionContentDTO]
    let notification: ActiveNotificationDTO
    let notificationCondition: NotificationConditionDTO
}

struct WithoutNotificationAddScenarioRequestDTO: Encodable {
    let scenarioName: String
    let memo: String
    let basicMissions: [BasicMissionContentDTO]
    let notification: InactiveNotificationDTO
}

struct BasicMissionContentDTO: Encodable {
    let content: String
}

extension WithNotificationAddScenarioRequestDTO {
    
    static func stub() -> Self {
        .init(
            scenarioName: "시나리오",
            memo: "메모",
            basicMissions: ["미션1", "미션2"].map { BasicMissionContentDTO(content: $0) },
            notification: .init(
                isActive: true,
                notificationType: "time",
                notificationMethodType: "push",
                daysOfWeekOrdinal: [0, 1, 2, 3, 4, 5, 6]
            ),
            notificationCondition: .init(
                notificationType: "time",
                startHour: 12,
                startMinute: 0
            )
        )
    }
}

extension WithoutNotificationAddScenarioRequestDTO {
    
    static func stub() -> Self {
        .init(
            scenarioName: "시나리오",
            memo: "미션",
            basicMissions: ["미션1", "미션2"].map { BasicMissionContentDTO(content: $0) },
            notification: .init(notificationType: "time")
        )
    }
}
