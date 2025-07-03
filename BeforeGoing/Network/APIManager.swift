import Alamofire

protocol APIManaging {
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: [String: Any]?,
        headers: HTTPHeaders?,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final class APIManager: APIManaging {
    static let shared = APIManager()
    private init() {}
    
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var newHeaders = headers
        newHeaders?.update(name: "Content-Type", value: "application/json")
        
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: newHeaders)
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
