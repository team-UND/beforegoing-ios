//
//  TermsMapper.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

struct TermsRequestMapper: Mapper {
    
    typealias Input = (termsOfServiceAgreed: Bool,
                       privacyPolicyAgreed: Bool,
                       isOver14: Bool,
                       eventPushAgreed: Bool)
    typealias Output = TermsRequestDTO
    
    func map(
        _ input: Input
    ) -> TermsRequestDTO {
        return .init(
            termsOfServiceAgreed: input.termsOfServiceAgreed,
            privacyPolicyAgreed: input.privacyPolicyAgreed,
            isOver14: input.isOver14,
            eventPushAgreed: input.eventPushAgreed
        )
    }
}
