//
//  DeleteScenarioUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

protocol DeleteScenarioType {
    
    func execute(scenarioID: Int) async throws
}

struct DeleteScenarioUseCase: DeleteScenarioType {
    
    private let repository: ScenarioInterface
    
    init(repository: ScenarioInterface) {
        self.repository = repository
    }
    
    func execute(scenarioID: Int) async throws {
        try await repository.deleteScenario(scenarioID: scenarioID)
    }
}

struct MockDeleteScenarioUseCase: DeleteScenarioType {
    
    func execute(scenarioID: Int) {}
}
