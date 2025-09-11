import Alamofire
import KakaoSDKAuth
import KakaoSDKUser

protocol APIManaging {
    func request<T: Decodable>(
        endPoint: EndPoint,
        responseType: T.Type
    ) async throws -> T
}

final class NetworkService: APIManaging {
    
    static let shared = NetworkService()
    private init() {}
    
    func request<T: Decodable>(
        endPoint: any EndPoint,
        responseType: T.Type
    ) async throws -> T {
        let dataRequest = AF.request(
            endPoint.url,
            method: endPoint.method,
            parameters: endPoint.bodyParameters,
            encoding: endPoint.parameterEncoding,
            headers: endPoint.headers
        )
            .validate()
        
        let response = try await dataRequest.serializingDecodable(T.self).value
        BeforeGoingLogger.network(response)
        BeforeGoingLogger.data(response)
        return response
    }
    
    @MainActor
    func requestKakaoIDToken(nonce: String?) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                handleLoginWithKakaoTalk(nonce: nonce, continuation: continuation)
                return
            }
            handleLoginWithKakaoAccount(nonce: nonce, continuation: continuation)
        }
    }
    
    private func handleLoginWithKakaoTalk(
        nonce: String?,
        continuation: CheckedContinuation<String, Error>
    ) {
        UserApi.shared.loginWithKakaoTalk(nonce: nonce) { ouathToken, error in
            self.handleIDTokenResult(ouathToken: ouathToken, error: error, continuation: continuation)
        }
    }
    
    private func handleLoginWithKakaoAccount(
        nonce: String?,
        continuation: CheckedContinuation<String, Error>
    ) {
        UserApi.shared.loginWithKakaoAccount(nonce: nonce) { ouathToken, error in
            self.handleIDTokenResult(ouathToken: ouathToken, error: error, continuation: continuation)
        }
    }
    
    private func handleIDTokenResult(
        ouathToken: OAuthToken?,
        error: Error?,
        continuation: CheckedContinuation<String, Error>
    ) {
        if let error {
            continuation.resume(throwing: BeforeGoingError.loginFailed)
            BeforeGoingLogger.error(error)
        } else {
            guard let idToken = ouathToken?.idToken else {
                continuation.resume(throwing: BeforeGoingError.idTokenMissing)
                return
            }
            continuation.resume(returning: idToken)
        }
    }
}
