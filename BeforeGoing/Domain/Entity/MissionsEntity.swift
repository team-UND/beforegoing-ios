//
//  MissionsEntity.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

struct MissionsEntity {
    let scenarioId: Int
    var basicMissions: [BasicMissionEntity]
    var todayMissions: [TodayMissionEntity]
}

struct BasicMissionEntity {
    let missionId: Int
    let content: String
    let isChecked: Bool
    let missionType: String
}

struct TodayMissionEntity {
    let missionId: Int
    let content: String
    let isChecked: Bool
    let missionType: String
}

extension MissionsEntity {
    
    static func stub() -> Self {
        return .init(
            scenarioId: 1,
            basicMissions: [BasicMissionEntity.stub()],
            todayMissions: [TodayMissionEntity.stub()]
        )
    }
}

extension BasicMissionEntity {
    
    static func stub() -> Self {
        return .init(
            missionId: 1,
            content: "내용",
            isChecked: true,
            missionType: "BASIC"
        )
    }
}

extension TodayMissionEntity {
    
    static func stub() -> Self {
        return .init(
            missionId: 1,
            content: "내용",
            isChecked: true,
            missionType: "TODAY"
        )
    }
}
