//
//  UserInterface.swift
//  BeforeGoing
//
//  Created by APPLE on 7/22/25.
//

protocol AuthInterface {
    
    func requestNonce(provider: Provider) async throws -> NonceEntity
    func requestLogin(provider: Provider) async throws -> Bool
    func requestLogin(provider: Provider, idToken: String, name: String?) async throws -> Bool
    func autoLogin() async throws -> Bool
    func getLastLogin() -> Provider?
    func logout() async throws
}
