//
//  UpdateScenarioRequestDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

enum UpdateScenarioRequestDTO: Encodable {
    case withNotification(WithNotificationUpdateScenarioRequestDTO)
    case withoutNotification(WithoutNotificationUpdateScenarioRequestDTO)
}

struct WithNotificationUpdateScenarioRequestDTO: Encodable {
    let scenarioName: String
    let memo: String
    let basicMissions: [MissionContentDTO]
    let notification: ActiveNotificationDTO
    let notificationCondition: NotificationConditionDTO
}

struct WithoutNotificationUpdateScenarioRequestDTO: Encodable {
    let scenarioName: String
    let memo: String
    let basicMissions: [MissionContentDTO]
    let notification: InactiveNotificationDTO
}

struct MissionContentDTO: Encodable {
    let missionId: Int?
    let content: String
}
