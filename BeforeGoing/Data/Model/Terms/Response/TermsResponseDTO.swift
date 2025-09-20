//
//  TermsResponseDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

struct TermsResponseDTO: Decodable {
    let id: Int
    let memberId: Int
    let termsOfServiceAgreed: Bool
    let privacyPolicyAgreed: Bool
    let isOver14: Bool
    let eventPushAgreed: Bool
}

extension TermsResponseDTO {
    
    func toEntity() -> TermsEntity {
        return .init(
            id: id,
            memberId: memberId,
            termsOfServiceAgreed: termsOfServiceAgreed,
            privacyPolicyAgreed: privacyPolicyAgreed,
            isOver14: isOver14,
            eventPushAgreed: eventPushAgreed
        )
    }
}
