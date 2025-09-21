//
//  UserInterface.swift
//  BeforeGoing
//
//  Created by APPLE on 7/22/25.
//

protocol AuthInterface {
    
    func requestNonce(provider: String) async throws -> NonceEntity
    func requestIDToken(nonce: String?) async throws -> String
    func requestKakaoLogin(provider: String, idToken: String) async throws -> Bool
    func autoLogin() async throws -> Bool
    func logout() async throws
}
