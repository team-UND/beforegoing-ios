import Alamofire
import KakaoSDKAuth
import KakaoSDKUser

protocol APIManaging {
    func request<T: Decodable>(
        endPoint: EndPoint,
        responseType: T.Type
    ) async throws -> T
    func request(endPoint: any EndPoint) async throws
    func requestKakaoIDToken(nonce: String?) async throws -> String
}

final class NetworkService: APIManaging {
    
    private let interceptor: NetworkInterceptor
    
    static let shared = NetworkService()
    private init() {
        self.interceptor = NetworkInterceptor(keyChainService: KeyChainService())
    }
    
    func request<T: Decodable>(
        endPoint: any EndPoint,
        responseType: T.Type
    ) async throws -> T {
        do {
            let dataRequest = createDataRequest(endPoint: endPoint)
            let response = try await dataRequest.serializingDecodable(T.self).value
            writeLog(response: response)
            return response
        } catch {
            if let afError = error.asAFError {
                throw handleError(afError: afError)
            }
            throw error
        }
    }
    
    func request(endPoint: any EndPoint) async throws  {
        do {
            let dataRequest = createDataRequest(endPoint: endPoint)
            let response = try await dataRequest.serializingData().value
            writeLog(response: response)
        } catch {
            throw error
        }
    }
    
    private func createDataRequest(endPoint: EndPoint) -> DataRequest {
        return AF.request(
            endPoint.requestURL,
            method: endPoint.method,
            parameters: endPoint.bodyParameters,
            encoding: endPoint.parameterEncoding,
            headers: endPoint.headers,
            interceptor: endPoint.isNeedReissue ? interceptor : nil
        )
        .validate()
    }
    
    private func writeLog<T: Decodable>(response: T) {
        BeforeGoingLogger.network(response)
        BeforeGoingLogger.data(response)
    }
    
    private func handleError(afError: AFError) -> BeforeGoingError {
        switch afError {
        case .responseValidationFailed(let reason):
            if case .unacceptableStatusCode(let statuscode) = reason {
                if statuscode == 304 {
                    return .notModifiedError
                }
                if statuscode == 400 {
                    return .badRequestError
                }
                if statuscode == 404 {
                    return .notFoundError
                }
                if statuscode == 429 {
                    return .tooManyRequset
                }
                if statuscode == 503 {
                    return .weatherServiceError
                }
            }
            return .unknownError
        default:
            return .unknownError
        }
    }
}

extension NetworkService {
    
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
