import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

final class MockUserAPI: UserAPIProtocol {
    var logoutFailed = true
    var oauthToken: OAuthToken = OAuthToken(
        accessToken: "",
        tokenType: "",
        refreshToken: "",
        scope: "",
        scopes: [""]
    )
    var loginFailedError: Error?
    var loginPerformed = false
    var shouldFailedWithKakaoLogin = true
    var user: KakaoSDKUser.User?
    var userInfoError: BeforeGoingError?
    let tokenData = """
        {
            "appId": 1234,
            "expiresIn": 3600
        }
        """.data(using: .utf8)!
    
    let userData = """
        {
            "nickname": 테스트 유저
        }
        """.data(using: .utf8)!
    
    var isErrorOccured = false
    var isSdkErrorOccured = false
    var isFetchUserErrorOccured = false
    
    func accessTokenInfo(completion: @escaping (KakaoSDKUser.AccessTokenInfo?, Error?) -> Void) {
        if isErrorOccured {
            if isSdkErrorOccured {
                loginPerformed = true
                return
            }
            completion(nil, BeforeGoingError.invalidToken)
            return
        }
        let tokenInfo = try! JSONDecoder().decode(AccessTokenInfo.self, from: tokenData)
        completion(tokenInfo, nil)
    }
    
    func logout(completion: @escaping (BeforeGoingError?) -> Void) {
        if logoutFailed {
            completion(BeforeGoingError.logoutFailed)
            return
        }
        completion(nil)
    }
    
    func isKakaoTalkLoginAvailable() -> Bool {
        return true
    }
    
    func loginWithKakaoTalk(nonce: String, completion: @escaping (KakaoSDKAuth.OAuthToken?, Error?) -> Void) {
        if shouldFailedWithKakaoLogin {
            completion(nil, BeforeGoingError.loginFailed)
            return
        }
        completion(oauthToken, nil)
    }
    
    func me(completion: @escaping (KakaoSDKUser.User?, BeforeGoingError?) -> Void) {
        if isFetchUserErrorOccured {
            completion(nil, .userInfoRequestFailed)
            return
        }
        self.user = try? JSONDecoder().decode(KakaoSDKUser.User.self, from: userData)
        completion(user, nil)
    }
}
