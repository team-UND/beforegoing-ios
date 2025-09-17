//
//  UpdateTermRequestMapper.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

struct UpdateTermRequestMapper: Mapper {
    
    typealias Input = Bool
    typealias Output = UpdateTermRequestDTO
    
    func map(_ input: Bool) -> UpdateTermRequestDTO {
        let requestDTO = UpdateTermRequestDTO(eventPushAgreed: input)
        return requestDTO
    }
}
