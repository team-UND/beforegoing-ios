struct RefreshResponseDTO: Decodable {
    let tokenType: String
    let accessToken: String
    let accessTokenExpiresIn: Int
    let refreshToken: String
    let refreshTokenExpiresIn: Int
}
