//
//  AddTodayMissionUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 10/1/25.
//

protocol AddTodayMissionType {
    func execute(scenarioID: Int, date: String, content: String) async throws -> TodayMissionEntity
}

struct AddTodayMissionUseCase: AddTodayMissionType {
    
    private let repository: MissionInterface
    
    init(repository: MissionInterface) {
        self.repository = repository
    }
    
    func execute(
        scenarioID: Int,
        date: String,
        content: String
    ) async throws -> TodayMissionEntity {
        let result = try await repository.addTodayMission(
            scenarioID: scenarioID,
            date: date,
            content: content
        )
        return result
    }
}

struct MockAddTodayMissionUseCase: AddTodayMissionType {
    
    func execute(
        scenarioID: Int,
        date: String,
        content: String
    ) async throws -> TodayMissionEntity {
        return .stub()
    }
}
