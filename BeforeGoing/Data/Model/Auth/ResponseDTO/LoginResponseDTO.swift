struct LoginResponseDTO: Decodable {
    let tokenType: String
    let accessToken: String
    let accessTokenExpiresIn: Int
    let refreshToken: String
    let refreshTokenExpiresIn: Int
}

extension LoginResponseDTO {
    func toEntity() -> LoginEntity {
        return LoginEntity(
            tokenType: tokenType,
            accessToken: accessToken,
            accessTokenExpiresIn: accessTokenExpiresIn,
            refreshToken: refreshToken,
            refreshTokenExpiresIn: refreshTokenExpiresIn
        )
    }
}
