struct TokensResponseDTO: Decodable {
    let tokenType: String
    let accessToken: String
    let accessTokenExpiresIn: Int
    let refreshToken: String
    let refreshTokenExpiresIn: Int
}

extension TokensResponseDTO {
    
    func toEntity() -> TokensEntity {
        return .init(
            tokenType: tokenType,
            accessToken: accessToken,
            accessTokenExpiresIn: accessTokenExpiresIn,
            refreshToken: refreshToken,
            refreshTokenExpiresIn: refreshTokenExpiresIn
        )
    }
}
