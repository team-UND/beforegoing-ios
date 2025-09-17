//
//  NonceMapper.swift
//  BeforeGoing
//
//  Created by APPLE on 9/10/25.
//

struct NonceRequestMapper: Mapper {
    
    typealias Input = String
    typealias Output = NonceRequestDTO
    
    func map(_ provider: String) -> NonceRequestDTO {
        return .init(provider: provider)
    }
}
