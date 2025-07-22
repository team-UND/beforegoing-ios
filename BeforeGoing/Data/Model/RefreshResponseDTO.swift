struct RefreshResponseDTO: Codable {
    let tokenType: String
    let accessToken: String
    let accessTokenExpiresIn: Int
    let refreshToken: String
    let refreshTokenExpiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case accessToken = "access_token"
        case accessTokenExpiresIn = "access_token_expires_in"
        case refreshToken = "refresh_token"
        case refreshTokenExpiresIn = "refresh_token_expires_in"
    }
}
