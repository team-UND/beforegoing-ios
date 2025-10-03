//
//  AddTodayMissionRequestMapper.swift
//  BeforeGoing
//
//  Created by APPLE on 10/1/25.
//

struct AddTodayMissionRequestMapper: Mapper {
    
    typealias Input = String
    typealias Output = AddTodayMissionRequestDTO
    
    func map(_ input: String) -> AddTodayMissionRequestDTO {
        return .init(content: input)
    }
}
