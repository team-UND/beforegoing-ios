import Alamofire

final class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    func request<T: Decodable>(
        url: String,
        method: HTTPMethodType,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        AF.request(url, method: method.type, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: responseType.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
