//
//  UpdateScenarioOrderRequestDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

struct UpdateScenarioOrderRequestDTO: Encodable {
    let prevOrder: Int?
    let nextOrder: Int?
}
