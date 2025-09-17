enum BeforeGoingError: Error {
    case decodingError
    case loginFailed
    case idTokenMissing
    case invalidToken
    case logoutFailed
    case userInfoRequestFailed
    case autoLoginFailed
    case diContainerError
    case reissueTokenFailed
    case agreeTermsFailed
    case updateNicknameFailed
}
