//
//  UpdateScenarioOrderRequestMapper.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

struct UpdateScenarioOrderRequestMapper: Mapper {
    
    typealias Input = (prevOrder: Int?, nextOrder: Int?)
    typealias Output = UpdateScenarioOrderRequestDTO
    
    func map(_ input: (prevOrder: Int?, nextOrder: Int?)) -> UpdateScenarioOrderRequestDTO {
        return .init(prevOrder: input.prevOrder, nextOrder: input.nextOrder)
    }
}
