//
//  FetchMissionsUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

protocol FetchMissionsType {
    func execute(scenarioID: Int, date: String) async throws -> MissionsEntity
}

struct FetchMissionsUseCase: FetchMissionsType {
    
    private let repository: MissionInterface
    
    init(repository: MissionInterface) {
        self.repository = repository
    }
    
    func execute(scenarioID: Int, date: String) async throws -> MissionsEntity {
        let result = try await repository.fetchMissions(
            scenarioID: scenarioID,
            date: date
        )
        return result
    }
}

struct MockFetchMissionsUseCase: FetchMissionsType {
    
    func execute(scenarioID: Int, date: String) async throws -> MissionsEntity {
        return .stub()
    }
}
