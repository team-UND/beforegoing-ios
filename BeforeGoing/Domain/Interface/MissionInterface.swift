//
//  MissionInterface.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

protocol MissionInterface {
    
    func execute(scenarioID: Int, date: String) async throws -> MissionsEntity
}
