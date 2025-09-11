//
//  UserInterface.swift
//  BeforeGoing
//
//  Created by APPLE on 7/22/25.
//

protocol AuthInterface {
    
    func requestNonce(dto: NonceRequestDTO) async throws -> NonceEntity
    func requestIDToken(nonce: String?) async throws -> String
    func requestKakaoLogin(dto: LoginRequestDTO) async throws -> LoginEntity
}
