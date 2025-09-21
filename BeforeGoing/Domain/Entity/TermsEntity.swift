//
//  TermsEntity.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

struct TermsEntity {
    let id: Int
    let memberId: Int
    let termsOfServiceAgreed: Bool
    let privacyPolicyAgreed: Bool
    let isOver14: Bool
    let eventPushAgreed: Bool
}

extension TermsEntity {
    
    static func stub() -> Self {
        return TermsEntity(
            id: 1,
            memberId: 1,
            termsOfServiceAgreed: true,
            privacyPolicyAgreed: true,
            isOver14: true,
            eventPushAgreed: true
        )
    }
}
