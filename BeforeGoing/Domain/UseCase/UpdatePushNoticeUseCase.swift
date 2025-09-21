//
//  UpdateUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

protocol UpdatePushNoticeType {
    
    func execute(eventPushAgreed: Bool) async throws
}

struct UpdatePushNoticeUseCase: UpdatePushNoticeType {
    
    private let repository: TermsInterface
    
    init(repository: TermsInterface) {
        self.repository = repository
    }
    
    func execute(eventPushAgreed: Bool) async throws {
        try await repository.updateAgreementTerm(eventPushAgreed: eventPushAgreed)
    }
}

struct MockUpdatePushNoticeUseCase: UpdatePushNoticeType {
    
    func execute(eventPushAgreed: Bool) {}
}
