enum BeforeGoingError: Error, Equatable {
    case urlNotFound
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
    case updatePushAgreedFailed
    case eventPushAgreedNotFound
    case accessTokenMissing
    case requestWeatherFailed
    case invalidParameter
    case getScenariosFailed
    case missionNotFound
    case networkError(statusCode: Int)
    case notFoundError
    case notModifiedError
    case badRequestError
    case weatherServiceError
    case unknownError
    case loginExpired
}
