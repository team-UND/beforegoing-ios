//
//  TermsRepositoryTest.swift
//  BeforeGoing
//
//  Created by APPLE on 2/3/26.
//

import CoreData
import Testing
@testable import BeforeGoing

struct TermsUseCaseTest {
    
    private let context: NSManagedObjectContext
    private let userDefaultsService: MockUserDefaultsService
    private let repository: TermsInterface
    private let fetchAgreeUseCase: FetchAgreeTermsUseCase
    private let sendAgreeTermsUseCase: SendAgreeTermsUseCase
    private let updatePushNoticeUseCase: UpdatePushNoticeUseCase
    
    init() async throws {
        self.context = ContextProvider.makeMockContext()
        self.userDefaultsService = .init()
        self.repository = TermsStorage(userDefaultsService: userDefaultsService, context: context)
        self.fetchAgreeUseCase = .init(repository: repository)
        self.sendAgreeTermsUseCase = .init(repository: repository)
        self.updatePushNoticeUseCase = .init(repository: repository)
        
        try await createMember(id: 1, nickname: "tester")
    }
    
    @Test("약관 동의 내역 저장", arguments: [true, false])
    func sendAgreeTerms_success(eventPushAgreed: Bool) async throws {
        try await sendAgreeTermsUseCase.execute(
            termsOfServiceAgreed: true,
            privacyPolicyAgreed: true,
            isOver14: true,
            eventPushAgreed: eventPushAgreed
        )
        
        let result = try await fetchAgreeUseCase.execute()
        
        #expect(result?.eventPushAgreed == eventPushAgreed)
    }
    
    @Test("약관 동의 내역 수정", arguments: [true, false])
    func fetchAgreeTerms_success(eventPushAgreed: Bool) async throws {
        try await sendAgreeTermsUseCase.execute(
            termsOfServiceAgreed: true,
            privacyPolicyAgreed: true,
            isOver14: true,
            eventPushAgreed: eventPushAgreed
        )
        
        try await updatePushNoticeUseCase.execute(eventPushAgreed: !eventPushAgreed)
        
        let result = try await fetchAgreeUseCase.execute()
        
        #expect(result?.eventPushAgreed == !eventPushAgreed)
    }
    
    private func createMember(id: Int, nickname: String) async throws {
        let _ = userDefaultsService.save(id, key: .userID)
        
        try await context.perform {
            let member = Member(context: self.context)
            member.id = Int64(id)
            member.nickname = nickname
            member.createdAt = .now
            member.updatedAt = .now
            try self.context.save()
        }
    }
}
