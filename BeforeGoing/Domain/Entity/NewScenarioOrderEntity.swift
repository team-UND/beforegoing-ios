//
//  NewScenarioOrderEntity.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

struct NewScenarioOrderEntity {
    let isReorder: Bool
    let orderUpdates: [NewOrderEntity]
}

struct NewOrderEntity {
    let id: Int
    let newOrder: Int
}

extension NewScenarioOrderEntity {
    static func stub() -> NewScenarioOrderEntity {
        .init(isReorder: true, orderUpdates: [NewOrderEntity.stub()])
    }
}

extension NewOrderEntity {
    static func stub() -> NewOrderEntity {
        .init(id: 0, newOrder: 1)
    }
}
