enum APIType {
    case login
    case nonce
    case tokens
    case hello
}

extension APIType {
    var url: String {
        switch self {
        case .login:
            return Environment.baseURL + "/api/v1/auth/login"
        case .nonce:
            return Environment.baseURL + "/api/v1/auth/nonce"
        case .tokens:
            return Environment.baseURL + "/api/v1/auth/tokens"
        case .hello:
            return Environment.baseURL + "/hello"
        }
    }
}
