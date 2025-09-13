//
//  TokenReissuer.swift
//  BeforeGoing
//
//  Created by APPLE on 9/12/25.
//

import Alamofire

struct TokenReissuer {
    
    private let keyChainService: KeyChainService
    
    init(keyChainService: KeyChainService) {
        self.keyChainService = keyChainService
    }
    
    func reissue() async throws {
        if let accessToken = keyChainService.load(key: KeyChainKey.accessToken.rawValue),
           let refreshToken = keyChainService.load(key: KeyChainKey.refreshToken.rawValue) {
            
            let tokensRequestDTO = TokensRequestDTO(accessToken: accessToken, refreshToken: refreshToken)
            let endPoint = AuthAPI.tokens(dto: tokensRequestDTO)
            
            do {
                let dataRequest = AF.request(
                    endPoint.url,
                    method: endPoint.method,
                    parameters: endPoint.bodyParameters,
                    encoding: endPoint.parameterEncoding,
                    headers: endPoint.headers
                )
                    .validate()
                
                let response = try await dataRequest.serializingDecodable(TokensResponseDTO.self).value
                keyChainService.save(response.accessToken, forKey: KeyChainKey.accessToken.rawValue)
                keyChainService.save(response.refreshToken, forKey: KeyChainKey.refreshToken.rawValue)
            } catch(let error) {
                BeforeGoingLogger.error(error)
            }
        }
    }
}
