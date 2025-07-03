enum APIType {
    case login
    case handshake
    case refresh
    case hello
}

extension APIType {
    var url: String {
        switch self {
        case .login:
            return Environment.baseURL + "/api/v1/auth/login"
        case .handshake:
            return Environment.baseURL + "/api/v1/auth/handshake"
        case .refresh:
            return Environment.baseURL + "/api/v1/auth/refresh"
        case .hello:
            return Environment.baseURL + "/hello"
        }
    }
}
