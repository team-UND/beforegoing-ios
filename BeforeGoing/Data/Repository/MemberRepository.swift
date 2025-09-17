//
//  MemberRepository.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

struct MemberRepository: MemberInterface {
    
    private let networkService: NetworkService
    private let keyChainService: KeyChainService
    private let termsMapper: TermsMapper
    
    init(networkService: NetworkService, keyChainService: KeyChainService, termsMapper: TermsMapper) {
        self.networkService = networkService
        self.keyChainService = keyChainService
        self.termsMapper = termsMapper
    }
    
    func sendAgreementTerms(
        termsOfServiceAgreed: Bool,
        privacyPolicyAgreed: Bool,
        isOver14: Bool,
        eventPushAgreed: Bool
    ) async throws {
        let requestDTO = termsMapper.map(
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
