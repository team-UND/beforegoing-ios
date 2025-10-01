//
//  MissionInterface.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

protocol MissionInterface {
    
    func fetchMissions(scenarioID: Int, date: String) async throws -> MissionsEntity
    func checkMission(missionID: Int, date: String, isChecked: Bool) async throws
    func addTodayMission(scenarioID: Int, date: String, content: String) async throws -> TodayMissionEntity
}
