//
//  UserInterface.swift
//  BeforeGoing
//
//  Created by APPLE on 7/22/25.
//

protocol AuthInterface {
    
    func requestNonce(provider: String) async throws -> NonceEntity
    func requestLogin(provider: String) async throws -> Bool
    func requestLogin(provider: String, idToken: String) async throws -> Bool
    func autoLogin() async throws -> Bool
    func logout() async throws
}
