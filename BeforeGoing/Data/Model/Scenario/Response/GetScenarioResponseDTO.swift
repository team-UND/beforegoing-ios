//
//  GetScenarioResponseDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

struct GetScenarioResponseDTO: Decodable {
    let scenarioId: Int
    let scenarioName: String
    let memo: String
    let basicMissions: [MissionDTO]
    let notification: AnyNotificationDTO
    let notificationCondition: NotificationConditionDTO?
}

struct MissionDTO: Decodable {
    let missionId: Int
    let content: String
    let isChecked: Bool
    let missionType: String
}

extension GetScenarioResponseDTO {
    
    func toEntity() -> ScenarioWithNotificationEntity {
        return .init(
            scenarioID: scenarioId,
            scenarioName: scenarioName,
            memo: memo,
            basicMissions: basicMissions.map { $0.toEntity() },
            notification: notification.toEntity(),
            notificationCondition: notificationCondition?.toEntity()
        )
    }
}

extension MissionDTO {
    
    func toEntity() -> MissionEntity {
        return .init(
            missionId: missionId,
            content: content,
            isChecked: isChecked,
            missionType: missionType
        )
    }
}
