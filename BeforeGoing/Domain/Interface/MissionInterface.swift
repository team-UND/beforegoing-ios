//
//  MissionInterface.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

protocol MissionInterface {
    
    func fetchMissions(scenarioID: Int, date: String) async throws -> MissionsEntity
}
