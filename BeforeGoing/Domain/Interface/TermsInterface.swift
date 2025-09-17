//
//  MemberInterface.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

protocol TermsInterface {
    
    func sendAgreementTerms(
        termsOfServiceAgreed: Bool,
        privacyPolicyAgreed: Bool,
        isOver14: Bool,
        eventPushAgreed: Bool
    ) async throws
    func updateAgreementTerm(eventPushAgreed: Bool) async throws
}
