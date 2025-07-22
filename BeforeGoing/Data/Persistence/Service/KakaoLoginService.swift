import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon
import Alamofire

final class KakaoLoginService {
    
    private let authAPI: AuthAPIProtocol.Type
    private let userAPI: UserAPIProtocol
    private let apiManager: APIManaging
    private let keyChainHelper: KeyChainProtocol
    private var nonce: String?
    
    init(
        authAPI: AuthAPIProtocol.Type,
        userAPI: UserAPIProtocol,
        apiManager: APIManaging,
        keyChainHelper: KeyChainProtocol
    ) {
        self.authAPI = authAPI
        self.userAPI = userAPI
        self.apiManager = apiManager
        self.keyChainHelper = keyChainHelper
    }
    
    // MARK: 카카오 로그인 체크
    func checkLoginStatus(completion: @escaping (Result<UserEntity, KakaoLoginError>) -> Void) {
        guard authAPI.hasToken() else {
            completion(.failure(.hasNotToken))
            return
        }
        
        userAPI.accessTokenInfo { (_, error) in
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
    func performLogin(completion: @escaping (Result<UserEntity, KakaoLoginError>) -> Void) {
        requestNonce { nonce in
            guard let nonce = nonce else {
                completion(.failure(.nonceRequestFailed))
                return
            }
            self.nonce = nonce
        }
    }
    
    // MARK: 카카오 로그아웃 수행
    func performLogout(completion: @escaping (Result<Void, KakaoLoginError>) -> Void) {
        userAPI.logout { error in
            if error != nil {
                completion(.failure(.logoutFailed))
                return
            }
            self.keyChainHelper.delete(key: KeyChainKey.accessToken.rawValue)
            completion(.success(()))
        }
    }
    
    // MARK: 서버에 nonce 요청
    private func requestNonce(completion: @escaping (String?) -> Void) {
        let parameters: [String: Any] = ["provider": Provider.kakao.rawValue]
        let url = APIType.nonce.url
        
        apiManager
            .request(
                url: url,
                method: .post,
                parameters: parameters,
                headers: nil,
                responseType: NonceResponseDTO.self
            ) { result in
                switch result {
                case .success(let data):
                    completion(data.nonce)
                case .failure:
                    completion(nil)
                }
            }
    }
    
    func loginWithKakao(completion: @escaping (Result<UserEntity, KakaoLoginError>) -> Void) {
        if userAPI.isKakaoTalkLoginAvailable() {
            guard let nonce = nonce else { return }
            userAPI.loginWithKakaoTalk(nonce: nonce) { (oauthToken, error) in
                if error != nil {
                    completion(.failure(.loginFailed))
                } else if let idToken = oauthToken?.idToken {
                    self.sendToServerIdToken(idToken: idToken) { _ in
                        self.fetchKakaoUserInfo(completion: completion)
                    }
                } else {
                    completion(.failure(.idTokenMissing))
                }
            }
        }
    }
    
    // MARK: id 토큰을 서버에 전송
    private func sendToServerIdToken(idToken: String, completion: @escaping (Result<Data, KakaoLoginError>) -> Void) {
        let parameters: [String: Any] = [
            "provider": Provider.kakao.rawValue,
            "id_token": idToken
        ]
        let url = APIType.login.url
        
        apiManager
            .request(
                url: url,
                method: .post,
                parameters: parameters,
                headers: nil,
                responseType: AccessTokenResponseDTO.self
            ) { result in
                switch result {
                case .success(let data):
                    self.keyChainHelper.save(data.accessToken, forKey: KeyChainKey.accessToken.rawValue)
                    self.keyChainHelper.save(data.refreshToken, forKey: KeyChainKey.refreshToken.rawValue)
                case .failure:
                    completion(.failure(.serverAuthFailed))
                }
            }
    }
    
    // MARK: 카카오 로그인 > 사용자 정보
    private func fetchKakaoUserInfo(completion: @escaping (Result<UserEntity, KakaoLoginError>) -> Void) {
        userAPI.me { (user, error) in
            guard error == nil,
                  let nickname = user?.kakaoAccount?.profile?.nickname
            else {
                completion(.failure(.userInfoRequestFailed))
                return
            }
            completion(.success(UserEntity(nickname: nickname)))
        }
    }
    
    func hello(completion: @escaping (String?) -> Void) {
        guard let accessToken = keyChainHelper.load(key: KeyChainKey.accessToken.rawValue) else { return }
        
        var headers = HTTPHeaders(arrayLiteral: HTTPHeader(name: "Authorization", value: accessToken))
        let url = APIType.hello.url
        
        apiManager
            .request(
                url: url,
                method: .get,
                parameters: nil,
                headers: headers,
                responseType: MessageResponseDTO.self
            ) { result in
                switch result {
                case .success(let data) :
                    completion(data.message)
                    print("Message : ", data.message)
                case .failure :
                    completion(nil)
                }
            }
    }
    
    func refresh(completion: @escaping (String?) -> Void) {
        guard let accessToken = keyChainHelper.load(key: KeyChainKey.accessToken.rawValue),
              let refreshToken = keyChainHelper.load(key: KeyChainKey.refreshToken.rawValue) else {
            return
        }
        
        let parameters: [String: Any] = [
            "access_token": accessToken,
            "refres_hToken": refreshToken
        ]
        let url = APIType.tokens.url
        
        apiManager
            .request(
                url: url,
                method: .post,
                parameters: parameters,
                headers: nil,
                responseType: RefreshResponseDTO.self
            ) { result in
                switch result {
                case .success(let data) :
                    print("Refresh : \(data.accessToken)")
                    print("Refresh : \(data.refreshToken)")
                    completion(data.accessToken)
                case .failure :
                    print("Refresh 실패")
                }
            }
    }
}
