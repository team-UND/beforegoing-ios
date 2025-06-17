import Alamofire

enum HTTPMethodType {
    case get
    case post
    case put
    case patch
    case delete
    
    var type: HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .patch:
            return .patch
        case .delete:
            return .delete
        }
    }
}
