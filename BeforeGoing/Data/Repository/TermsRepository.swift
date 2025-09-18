//
//  MemberRepository.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

struct TermsRepository: TermsInterface {
    
    private let networkService: NetworkService
    private let keyChainService: KeyChainService
    private let termsRequestMapper: TermsRequestMapper
    private let updateTermRequestMapper: UpdateTermRequestMapper
    
    init(
        networkService: NetworkService,
        keyChainService: KeyChainService,
        termsRequestMapper: TermsRequestMapper,
        updateTermRequestMapper: UpdateTermRequestMapper
    ) {
        self.networkService = networkService
        self.keyChainService = keyChainService
        self.termsRequestMapper = termsRequestMapper
        self.updateTermRequestMapper = updateTermRequestMapper
    }
    
    func getAgreementTerms() async throws -> TermsEntity? {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return nil
        }
        
        let responseDTO = try await networkService.request(
            endPoint: TermsAPI.getTerms(accessToken: accessToken),
            responseType: TermsResponseDTO.self
        )
        return responseDTO.toEntity()
    }
    
    func sendAgreementTerms(
        termsOfServiceAgreed: Bool,
        privacyPolicyAgreed: Bool,
        isOver14: Bool,
        eventPushAgreed: Bool
    ) async throws {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return
        }
        
        let requestDTO = termsRequestMapper.map(
            (
                termsOfServiceAgreed: termsOfServiceAgreed,
                privacyPolicyAgreed: privacyPolicyAgreed,
                isOver14: isOver14,
                eventPushAgreed: eventPushAgreed
            )
        )
        let _ = try await networkService.request(
            endPoint: TermsAPI.sendTerms(accessToken: accessToken, dto: requestDTO),
            responseType: TermsResponseDTO.self
        )
    }
    
    func updateAgreementTerm(eventPushAgreed: Bool) async throws {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return
        }
        
        let requestDTO = updateTermRequestMapper.map(eventPushAgreed)
        let _ = try await networkService.request(
            endPoint: TermsAPI.updateTerm(accessToken: accessToken, dto: requestDTO),
            responseType: TermsResponseDTO.self
        )
    }
}
