import UIKit

enum APIType {
    case login
    case handshake
    case refresh
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
        }
    }
}
