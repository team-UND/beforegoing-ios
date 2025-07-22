import KakaoSDKAuth

protocol AuthAPIProtocol {
    static func hasToken() -> Bool
}

struct AuthAPIWrapper: AuthAPIProtocol {
    static func hasToken() -> Bool {
        return AuthApi.hasToken()
    }
}
