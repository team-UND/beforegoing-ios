import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

final class KakaoLoginService {
    
    // MARK: 카카오 로그인 체크
    func checkLoginStatus(completion: @escaping (Result<User, KakaoLoginError>) -> Void) {
        guard AuthApi.hasToken() else {
            completion(.failure(.invalidToken))
            return
        }
        
        UserApi.shared.accessTokenInfo { (_, error) in
            if let error = error {
                if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() {
                    self.performLogin(completion: completion)
                    return
                }
                completion(.failure(.invalidToken))
                return
            }
            self.fetchKakaoUserInfo(completion: completion)
        }
    }
    
    // MARK: 카카오 로그인 수행
    func performLogin(completion: @escaping (Result<User, KakaoLoginError>) -> Void) {
        requestNonce { nonce in
            guard let nonce = nonce else {
                completion(.failure(.nonceRequestFailed))
                return
            }
            
            self.loginWithKakao(nonce: nonce, completion: completion)
        }
    }
    
    // MARK: 카카오 로그아웃 수행
    func performLogout(completion: @escaping (Result<Void, KakaoLoginError>) -> Void) {
        UserApi.shared.logout { error in
            if error != nil {
                completion(.failure(.logoutFailed))
                return
            }
            KeyChainHelper.delete(key: KeyChainKey.accessToken.rawValue)
            completion(.success(()))
        }
    }
    
    // MARK: 서버에 nonce 요청
    private func requestNonce(completion: @escaping (String?) -> Void) {
        let parameters: [String: Any] = ["provider": Provider.kakao.rawValue]
        let url = APIType.handshake.url
        
        APIManager.shared
            .request(url: url, method: .post, parameters: parameters, responseType: NonceResponseModel.self) { result in
                switch result {
                case .success(let data) :
                    completion(data.nonce)
                case .failure :
                    completion(nil)
                }
            }
    }
    
    private func loginWithKakao(nonce: String, completion: @escaping (Result<User, KakaoLoginError>) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk(nonce: nonce) { (oauthToken, error) in
                if error != nil {
                    completion(.failure(.loginFailed))
                } else if let idToken = oauthToken?.idToken {
                    self.requestAccessToken(idToken: idToken) { _ in
                        self.fetchKakaoUserInfo(completion: completion)
                    }
                } else {
                    completion(.failure(.idTokenMissing))
                }
            }
        }
    }
    
    // MARK: id 토큰을 서버에 전송
    private func requestAccessToken(idToken: String, completion: @escaping (Result<Data, KakaoLoginError>) -> Void) {
        let parameters: [String: Any] = [
            "provider": Provider.kakao.rawValue,
            "id_token": idToken
        ]
        let url = APIType.login.url
        
        APIManager.shared.request(url: url, method: .post, parameters: parameters, responseType: AccessTokenResponseModel.self) { result in
            switch result {
            case .success(let data) :
                KeyChainHelper.save(data.accessToken, forKey: KeyChainKey.accessToken.rawValue)
            case .failure :
                completion(.failure(.serverAuthFailed))
            }
        }
    }
    
    // MARK: 카카오 로그인 > 사용자 정보
    private func fetchKakaoUserInfo(completion: @escaping (Result<User, KakaoLoginError>) -> Void) {
        UserApi.shared.me { (user, error) in
            guard error == nil,
                  let nickname = user?.kakaoAccount?.profile?.nickname
            else {
                completion(.failure(.userInfoRequestFailed))
                return
            }
            completion(.success(User(nickname: nickname)))
        }
    }
}
