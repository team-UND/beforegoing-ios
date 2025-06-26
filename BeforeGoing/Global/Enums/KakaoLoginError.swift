enum KakaoLoginError: Error {
    case hasNotToken
    case invalidToken
    case loginFailed
    case idTokenMissing
    case logoutFailed
    case nonceRequestFailed
    case userInfoRequestFailed
    case serverAuthFailed
}
