//
//  UpdateScenarioUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

protocol UpdateScenarioType {
    func execute(
        scenarioID: Int,
        scenarioName: String,
        memo: String,
        missions: [(missionID: Int?, content: String)],
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?,
        startHour: Int?,
        startMinute: Int?
    ) async throws -> ScenarioEntity
}

struct UpdateScenarioUseCase: UpdateScenarioType {
    
    private let repository: ScenarioInterface
    
    init(repository: ScenarioInterface) {
        self.repository = repository
    }
    
    func execute(
        scenarioID: Int,
        scenarioName: String,
        memo: String,
        missions: [(missionID: Int?, content: String)],
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?,
        startHour: Int?,
        startMinute: Int?
    ) async throws -> ScenarioEntity {
        try await repository
            .updateScenario(
                scenarioID: scenarioID,
                scenarioName: scenarioName,
                memo: memo,
                missions: missions,
                isNotificationActive: isNotificationActive,
                noticeMethodType: noticeMethodType,
                daysOfWeekOrdinal: daysOfWeekOrdinal,
                startHour: startHour,
                startMinute: startMinute
            )
    }
}

struct MockUpdateScenarioUseCase: UpdateScenarioType {
    
    func execute(
        scenarioID: Int,
        scenarioName: String,
        memo: String,
        missions: [(missionID: Int?, content: String)],
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?,
        startHour: Int?,
        startMinute: Int?
    ) -> ScenarioEntity {
        return .stub()
    }
}
