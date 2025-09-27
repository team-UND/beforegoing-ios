//
//  AgreeTermsUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

protocol SendAgreeTermsType {
    
    func execute(
        termsOfServiceAgreed: Bool,
        privacyPolicyAgreed: Bool,
        isOver14: Bool,
        eventPushAgreed: Bool
    ) async throws
}

struct SendAgreeTermsUseCase: SendAgreeTermsType {
    
    private let repository: TermsInterface
    
    init(repository: TermsInterface) {
        self.repository = repository
    }
    
    func execute(
        termsOfServiceAgreed: Bool,
        privacyPolicyAgreed: Bool,
        isOver14: Bool,
        eventPushAgreed: Bool
    ) async throws {
        try await repository.sendAgreementTerms(
            termsOfServiceAgreed: termsOfServiceAgreed,
            privacyPolicyAgreed: privacyPolicyAgreed,
            isOver14: isOver14,
            eventPushAgreed: eventPushAgreed
        )
    }
}

struct MockSendAgreeTermsUseCase: SendAgreeTermsType {
    
    func execute(
        termsOfServiceAgreed: Bool,
        privacyPolicyAgreed: Bool,
        isOver14: Bool,
        eventPushAgreed: Bool
    ) {}
}
