//
//  MemberRepository.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

struct MemberRepository: MemberInterface {
    
    private let networkService: NetworkService
    private let keyChainService: KeyChainService
    private let termsRequestMapper: TermsRequestMapper
    
    init(networkService: NetworkService, keyChainService: KeyChainService, termsRequestMapper: TermsRequestMapper) {
        self.networkService = networkService
        self.keyChainService = keyChainService
        self.termsRequestMapper = termsRequestMapper
    }
    
    func sendAgreementTerms(
        termsOfServiceAgreed: Bool,
        privacyPolicyAgreed: Bool,
        isOver14: Bool,
        eventPushAgreed: Bool
    ) async throws {
        let requestDTO = termsRequestMapper.map(
            (
                termsOfServiceAgreed: termsOfServiceAgreed,
                privacyPolicyAgreed: privacyPolicyAgreed,
                isOver14: isOver14,
                eventPushAgreed: eventPushAgreed
            )
        )
        let accessToken = keyChainService.load(key: "accessToken") ?? ""
        let _ = try await networkService.request(
            endPoint: MemberAPI.terms(accessToken: accessToken, dto: requestDTO),
            responseType: TermsResponseDTO.self
        )
    }
}
