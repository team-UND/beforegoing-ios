//
//  TermsRequestDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

struct TermsRequestDTO: Encodable {
    let termsOfServiceAgreed: Bool
    let privacyPolicyAgreed: Bool
    let isOver14: Bool
    let eventPushAgreed: Bool
}
