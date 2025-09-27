//
//  FetchScenarioUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

protocol FetchScenariosType {
    func execute() async throws -> [ScenarioEntity]
}

struct FetchScenariosUseCase: FetchScenariosType {
    
    private let repository: ScenarioInterface
    
    init(repository: ScenarioInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> [ScenarioEntity] {
        let result = try await repository.fetchScenarios()
        return result
    }
}

struct MockFetchScenariosUseCase: FetchScenariosType {
    
    func execute() async throws -> [ScenarioEntity] {
        return [.stub()]
    }
}
