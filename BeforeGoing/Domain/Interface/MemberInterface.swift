//
//  MemberInterface.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

protocol MemberInterface {
    
    func sendAgreementTerms(
        termsOfServiceAgreed: Bool,
        privacyPolicyAgreed: Bool,
        isOver14: Bool,
        eventPushAgreed: Bool
    ) async throws
}
