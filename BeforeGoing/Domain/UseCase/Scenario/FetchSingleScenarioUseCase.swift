//
//  FetchSingleScenarioUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

protocol FetchSingleScenarioType {
    func execute(scenarioID: Int) async throws -> ScenarioWithNotificationEntity
}

struct FetchSingleScenarioUseCase: FetchSingleScenarioType {
    
    private let repository: ScenarioInterface
    
    init(repository: ScenarioInterface) {
        self.repository = repository
    }
    
    func execute(scenarioID: Int) async throws -> ScenarioWithNotificationEntity {
        let result = try await repository.fetchScenario(scenarioID: scenarioID)
        return result
    }
}

struct MockFetchSingleScenarioUseCase: FetchSingleScenarioType {
    
    func execute(scenarioID: Int) -> ScenarioWithNotificationEntity {
        return .stub()
    }
}
