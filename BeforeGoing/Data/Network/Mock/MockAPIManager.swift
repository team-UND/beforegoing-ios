import Alamofire
import Foundation

final class MockAPIManager: APIManaging {
    
    var nonce: NonceResponseDTO? = NonceResponseDTO(nonce: "nonce")
    var accessToken: AccessTokenResponseDTO? = AccessTokenResponseDTO(
        tokenType: "",
        accessToken: "accessToken",
        accessTokenExpiresIn: 0,
        refreshToken: "",
        refreshTokenExpiresIn: 0
    )
    var shouldFailed = true
    
    func request<T>(
        url: String,
        method: HTTPMethod,
        parameters: [String : Any]?,
        headers: HTTPHeaders?,
        responseType: T.Type,
        completion: @escaping (Result<T, any Error>) -> Void
    ) where T : Decodable {
        if shouldFailed {
            if T.self == NonceResponseDTO.self {
                completion(.failure(KakaoLoginError.nonceRequestFailed))
                return
            } else if T.self == AccessTokenResponseDTO.self {
                completion(.failure(KakaoLoginError.idTokenMissing))
                return
            }
        }

        if T.self == NonceResponseDTO.self, let nonce = nonce as? T {
            completion(.success(nonce))
        } else if T.self == AccessTokenResponseDTO.self, let accessToken = accessToken as? T {
            completion(.success(accessToken))
        }
    }
}
