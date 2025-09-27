//
//  ScenarioWithNotificationEntity.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

struct ScenarioWithNotificationEntity {
    let scenarioID: Int
    let scenarioName: String
    let memo: String
    let basicMissions: [MissionEntity]
    let notification: AnyNotificationEntity
    let notificationCondition: NotificationConditionEntity?
}

struct MissionEntity {
    let missionId: Int
    let content: String
    let isChecked: Bool
    let missionType: String
}

extension ScenarioWithNotificationEntity {
    
    static func stub() -> Self {
        .init(
            scenarioID: 1,
            scenarioName: "이름",
            memo: "메모",
            basicMissions: [MissionEntity.stub()],
            notification: AnyNotificationEntity.stub(),
            notificationCondition: NotificationConditionEntity.stub()
        )
    }
}

extension MissionEntity {
    
    static func stub() -> Self {
        .init(
            missionId: 1,
            content: "내용",
            isChecked: true,
            missionType: "BASIC"
        )
    }
}
