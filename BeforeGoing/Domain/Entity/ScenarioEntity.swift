//
//  ScenarioEntity.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

struct ScenarioEntity {
    let scenarioId: Int
    let scenarioName: String
    let memo: String
    var scenarioOrder: Int
}

extension ScenarioEntity {
    static func stub() -> Self {
        .init(scenarioId: 0, scenarioName: "", memo: "", scenarioOrder: 0)
    }
}
