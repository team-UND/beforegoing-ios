//
//  UpdateNicknameRequestMapper.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

struct UpdateNicknameRequestMapper: Mapper {
    
    typealias Input = String
    typealias Output = UpdateNicknameRequestDTO
    
    func map(_ input: Input) -> Output {
        return .init(nickname: input)
    }
}
