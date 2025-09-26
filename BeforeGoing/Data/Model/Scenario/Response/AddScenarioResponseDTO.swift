//
//  AddScenarioResponseDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

struct AddScenarioResponseDTO: Decodable {
    let scenarioId: Int
    let scenarioName: String
    let memo: String
    let scenarioOrder: Int
}

extension AddScenarioResponseDTO {
    
    func toEntity() -> ScenarioEntity {
        .init(
            scenarioId: scenarioId,
            scenarioName: scenarioName,
            memo: memo,
            scenarioOrder: scenarioOrder
        )
    }
}
