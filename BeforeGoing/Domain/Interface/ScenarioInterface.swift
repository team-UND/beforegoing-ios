//
//  ScenarioInterface.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

protocol ScenarioInterface {
    
    func addScenario(
        scenarioName: String,
        memo: String,
        basicMissions: [String],
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?,
        startHour: Int?,
        startMinute: Int?
    ) async throws -> ScenarioEntity
    func fetchScenarios() async throws -> [ScenarioEntity]
}
