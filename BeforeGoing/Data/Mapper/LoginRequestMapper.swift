//
//  LoginRequestMapper.swift
//  BeforeGoing
//
//  Created by APPLE on 9/11/25.
//

struct LoginRequestMapper: Mapper {
    
    typealias Input = (provider: String, idToken: String)
    typealias Output = LoginRequestDTO

    func map(_ input: Input) -> Output {
        return Output(provider: input.provider, idToken: input.idToken)
    }
}
