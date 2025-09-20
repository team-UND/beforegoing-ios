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
        guard let accessToken = keyChainService.load(key: .accessToken),
           let refreshToken = keyChainService.load(key: .refreshToken) else {
            throw BeforeGoingError.reissueTokenFailed
        }
        
        let endPoint = readyToRequestTokens(accessToken: accessToken, refreshToken: refreshToken)
        do {
            let dataRequest = createDataRequest(endPoint: endPoint)
            let response = try await dataRequest.serializingDecodable(TokensResponseDTO.self).value
            saveNewTokens(response: response)
        } catch(let error) {
            BeforeGoingLogger.error(error)
            throw error
        }
    }
    
    private func readyToRequestTokens(accessToken: String, refreshToken: String) -> EndPoint {
        let tokensRequestDTO = TokensRequestDTO(accessToken: accessToken, refreshToken: refreshToken)
        let endPoint = AuthAPI.tokens(dto: tokensRequestDTO)
        return endPoint
    }
    
    private func createDataRequest(endPoint: EndPoint) -> DataRequest {
        return AF.request(
            endPoint.url,
            method: endPoint.method,
            parameters: endPoint.bodyParameters,
            encoding: endPoint.parameterEncoding,
            headers: endPoint.headers
        )
            .validate()
    }
    
    private func saveNewTokens(response: TokensResponseDTO) {
        keyChainService.save(response.accessToken, forKey: .accessToken)
        keyChainService.save(response.refreshToken, forKey: .refreshToken)
    }
}
