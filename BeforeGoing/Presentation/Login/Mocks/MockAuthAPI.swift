final class MockAuthAPI : AuthAPIProtocol {
    
    static var tokenCondition = false

    static func hasToken() -> Bool {
        return self.tokenCondition
    }
}
