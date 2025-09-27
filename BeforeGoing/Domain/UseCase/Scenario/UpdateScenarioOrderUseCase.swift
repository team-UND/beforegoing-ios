//
//  UpdateScenarioOrderUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

protocol UpdateScenarioOrderType {
    func execute(
        scenarioID: Int,
        prevOrder: Int?,
        nextOrder: Int?
    ) async throws -> NewScenarioOrderEntity
}

struct UpdateScenarioOrderUseCase: UpdateScenarioOrderType {
    
    private let repository: ScenarioInterface
    
    init(repository: ScenarioInterface) {
        self.repository = repository
    }
    
    func execute(
        scenarioID: Int,
        prevOrder: Int?,
        nextOrder: Int?
    ) async throws -> NewScenarioOrderEntity {
        let result = try await repository.updateScenarioOrder(
            scenarioID: scenarioID,
            prevOrder: prevOrder,
            nextOrder: nextOrder
        )
        return result
    }
}

struct MockUpdateScenarioOrderUseCase: UpdateScenarioOrderType {
    
    func execute(
        scenarioID: Int,
        prevOrder: Int?,
        nextOrder: Int?
    ) -> NewScenarioOrderEntity {
        .stub()
    }
}
