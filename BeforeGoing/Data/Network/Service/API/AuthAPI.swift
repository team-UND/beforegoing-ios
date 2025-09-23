import Alamofire

enum AuthAPI {
    case login(dto: LoginRequestDTO)
    case nonce(dto: NonceRequestDTO)
    case tokens(dto: TokensRequestDTO)
    case logout(accessToken: String)
}

extension AuthAPI: EndPoint {
    
    var basePath: String {
        "/v1/auth"
    }
    
    var url: String {
        let basePath = Environment.baseURL + basePath
        
        switch self {
        case .login:
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
        case .login, .nonce, .tokens:
            return .post
        case .logout:
            return .delete
        }
    }

    var parameters: [String : Any]? {
        nil
    }

    var headers: HTTPHeaders? {
        switch self {
        case .login, .nonce, .tokens:
            ["Content-Type": "application/json"]
        case .logout(let accessToken):
            [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }

    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .login, .nonce, .tokens:
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
        case .login(let dto):
            return try? dto.toBodyParameters()
        case .nonce(let dto):
            return try? dto.toBodyParameters()
        case .tokens(let dto):
            return try? dto.toBodyParameters()
        case .logout:
            return nil
        }
    }
    
    var isNeedReissue: Bool {
        switch self {
        case .nonce, .login:
            return false
        case .tokens, .logout:
            return true
        }
    }
}
