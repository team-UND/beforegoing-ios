enum KakaoLoginError: Error {
    case invalidToken
    case loginFailed
    case idTokenMissing
    case logoutFailed
    case nonceRequestFailed
    case userInfoRequestFailed
    case serverAuthFailed
}
