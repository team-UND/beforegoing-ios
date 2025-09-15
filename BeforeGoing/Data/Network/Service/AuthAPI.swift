import Alamofire

enum AuthAPI {
    case kakaoLogin(dto: LoginRequestDTO)
    case nonce(dto: NonceRequestDTO)
    case tokens(dto: TokensRequestDTO)
    case logout
}

extension AuthAPI: EndPoint {
    
    var basePath: String {
        "/v1/auth"
    }
    
    var url: String {
        let basePath = Environment.baseURL + basePath
        
        switch self {
        case .kakaoLogin:
            return basePath + "/login"
        case .nonce:
            return basePath + "/nonce"
        case .tokens:
            return basePath + "/tokens"
        case .logout:
            return basePath + "/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .kakaoLogin, .nonce, .tokens:
            return .post
        case .logout:
            return .delete
        }
    }

    var parameters: [String : Any]? {
        nil
    }

    var headers: HTTPHeaders? {
        ["Content-Type": "application/json"]
    }

    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .kakaoLogin, .nonce, .tokens:
            return JSONEncoding.default
        case .logout:
            return URLEncoding.default
        }
    }

    var queryParameters: [String : String]? {
        nil
    }

    var bodyParameters: Parameters? {
        switch self {
        case .kakaoLogin(let dto):
            return try? dto.toBodyParameters()
        case .nonce(let dto):
            return try? dto.toBodyParameters()
        case .tokens(let dto):
            return try? dto.toBodyParameters()
        case .logout:
            return nil
        }
    }
}
