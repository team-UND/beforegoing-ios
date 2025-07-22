import KakaoSDKUser
import KakaoSDKAuth

protocol UserAPIProtocol {
    func accessTokenInfo(completion: @escaping (AccessTokenInfo?, Error?) -> Void)
    func logout(completion: @escaping (KakaoLoginError?) -> Void)
    func isKakaoTalkLoginAvailable() -> Bool
    func loginWithKakaoTalk(nonce: String, completion: @escaping (OAuthToken?, Error?) -> Void)
    func me(completion: @escaping (KakaoSDKUser.User?, KakaoLoginError?) -> Void)
}

struct UserAPIWrapper: UserAPIProtocol {
    func accessTokenInfo(completion: @escaping (KakaoSDKUser.AccessTokenInfo?, Error?) -> Void) {
        UserApi.shared.accessTokenInfo(completion: completion)
    }
    
    func logout(completion: @escaping (KakaoLoginError?) -> Void) {
        UserApi.shared.logout { error in
            completion(error as? KakaoLoginError)
        }
    }
    
    func isKakaoTalkLoginAvailable() -> Bool {
        return UserApi.isKakaoTalkLoginAvailable()
    }
    
    func loginWithKakaoTalk(nonce: String, completion: @escaping (KakaoSDKAuth.OAuthToken?, Error?) -> Void) {
        UserApi.shared.loginWithKakaoTalk(nonce: nonce, completion: completion)
    }
    
    func me(completion: @escaping (KakaoSDKUser.User?, KakaoLoginError?) -> Void) {
        UserApi.shared.me { user, error in
            completion(user, error as? KakaoLoginError)
        }
    }
    
}
