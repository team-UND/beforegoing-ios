//
//  AddScenarioUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

protocol AddScenarioType {
    func execute(
        scenarioName: String,
        memo: String,
        basicMissions: [String],
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?,
        startHour: Int?,
        startMinute: Int?
    ) async throws -> ScenarioEntity
}

struct AddScenarioUseCase: AddScenarioType {
    
    private let repository: ScenarioInterface
    
    init(repository: ScenarioInterface) {
        self.repository = repository
    }
    
    func execute(
        scenarioName: String,
        memo: String,
        basicMissions: [String],
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?,
        startHour: Int?,
        startMinute: Int?
    ) async throws -> ScenarioEntity {
        let result = try await repository.addScenario(
            scenarioName: scenarioName,
            memo: memo,
            basicMissions: basicMissions,
            isNotificationActive: isNotificationActive,
            noticeMethodType: noticeMethodType,
            daysOfWeekOrdinal: daysOfWeekOrdinal,
            startHour: startHour,
            startMinute: startMinute
        )
        return result
    }
}

struct MockAddScenarioUseCase: AddScenarioType {
    
    func execute(
        scenarioName: String,
        memo: String,
        basicMissions: [String],
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?,
        startHour: Int?,
        startMinute: Int?
    ) async throws -> ScenarioEntity {
        .stub()
    }
}
