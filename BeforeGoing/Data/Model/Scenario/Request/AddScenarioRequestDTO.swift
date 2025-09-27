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
