//
//  UpdateScenarioOrderResponseDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

struct UpdateScenarioOrderResponseDTO: Decodable {
    let isReorder: Bool
    let orderUpdates: [OrderUpdateDTO]
}

struct OrderUpdateDTO: Decodable {
    let id: Int
    let newOrder: Int
}

extension UpdateScenarioOrderResponseDTO {
    func toEntity() -> NewScenarioOrderEntity {
        return .init(
            isReorder: isReorder,
            orderUpdates: orderUpdates.map { $0.toEntity() }
        )
    }
}

extension OrderUpdateDTO {
    func toEntity() -> NewOrderEntity {
        .init(
            id: id,
            newOrder: newOrder
        )
    }
}
