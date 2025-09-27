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
    func fetchScenario(scenarioID: Int) async throws -> ScenarioWithNotificationEntity
    func fetchScenarios() async throws -> [ScenarioEntity]
    func deleteScenario(scenarioID: Int) async throws
    func updateScenarioOrder(
        scenarioID: Int,
        prevOrder: Int?,
        nextOrder: Int?
    ) async throws -> NewScenarioOrderEntity
}
