//
//  LoginEntity.swift
//  BeforeGoing
//
//  Created by APPLE on 9/11/25.
//

struct LoginEntity {
    let tokenType: String
    let accessToken: String
    let accessTokenExpiresIn: Int
    let refreshToken: String
    let refreshTokenExpiresIn: Int
    let isNewMember: Bool
}
