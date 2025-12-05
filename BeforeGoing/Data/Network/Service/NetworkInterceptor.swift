//
//  NetworkInterceptor.swift
//  BeforeGoing
//
//  Created by APPLE on 9/12/25.
//

import Foundation

import Alamofire

struct NetworkInterceptor: RequestInterceptor {
    
    private let keyChainService: KeyChainService
    private let tokenReissuer: TokenReissuer
    
    init(keyChainService: KeyChainService) {
        self.keyChainService = keyChainService
        self.tokenReissuer = TokenReissuer(keyChainService: keyChainService)
    }
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        guard urlRequest.url?.absoluteString.hasPrefix(Environment.baseURL) == true,
              let accessToken = keyChainService.load(key: .accessToken) else {
            completion(.success(urlRequest))
            return
        }
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        Task {
            do {
                try await tokenReissuer.reissue()
            } catch (let error) {
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
