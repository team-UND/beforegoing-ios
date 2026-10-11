enum BeforeGoingError: Error, Equatable {
    case serviceUnavailable
    case diContainerError
    case agreeTermsFailed
    case updateNicknameFailed
    case updatePushAgreedFailed
    case eventPushAgreedNotFound
    case getScenariosFailed
    case missionNotFound
    case notFoundError
    case unknownError
    case missionLimitError
    case tooManyRequset
    
    case userIDNotFound
    case memberNotFound
    case termsNotFound
    case scenarioNotFound
    case notificationNotFound
    case invalidMissionType
    case invalidDateFormat
}
