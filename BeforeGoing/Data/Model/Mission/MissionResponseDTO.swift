//
//  MissionResponseDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

struct MissionResponseDTO: Decodable {
    let scenarioId: Int
    let basicMissions: [BasicMissionDTO]
    let todayMissions: [TodayMissionDTO]
}

struct BasicMissionDTO: Decodable {
    let missionId: Int
    let content: String
    let isChecked: Bool
    let missionType: String
}

struct TodayMissionDTO: Decodable {
    let missionId: Int
    let content: String
    let isChecked: Bool
    let missionType: String
}

extension MissionResponseDTO {
    
    func toEntity() -> MissionsEntity {
        return .init(
            scenarioId: scenarioId,
            basicMissions: basicMissions.map { $0.toEntity() },
            todayMissions: todayMissions.map { $0.toEntity() }
        )
    }
}

extension BasicMissionDTO {
    
    func toEntity() -> BasicMissionEntity {
        return .init(
            missionId: missionId,
            content: content,
            isChecked: isChecked,
            missionType: missionType
        )
    }
}

extension TodayMissionDTO {
    
    func toEntity() -> TodayMissionEntity {
        return .init(
            missionId: missionId,
            content: content,
            isChecked: isChecked,
            missionType: missionType
        )
    }
}
