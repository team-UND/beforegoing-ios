//
//  TermsStorage.swift
//  BeforeGoing
//
//  Created by APPLE on 2/2/26.
//

import CoreData
import Foundation

final class TermsStorage: TermsInterface {
    
    private let userDefaultsService: UserDefaultsProtocol
    private let context: NSManagedObjectContext
    
    init(
        userDefaultsService: UserDefaultsProtocol,
        context: NSManagedObjectContext
    ) {
        self.userDefaultsService = userDefaultsService
        self.context = context
    }
    
    func getAgreementTerms() async throws -> TermsEntity? {
        try await context.perform {
            let member = try self.fetchMember()
            
            guard let terms = member.term else {
                return nil
            }
            
            return TermsEntity(
                id: Int(terms.id),
                memberId: Int(member.id),
                termsOfServiceAgreed: terms.termsOfServiceAgreed,
                privacyPolicyAgreed: terms.privacyPolicyAgreed,
                isOver14: terms.isOverFourteen,
                eventPushAgreed: terms.eventPushAgreed
            )
        }
    }
    
    func sendAgreementTerms(
        termsOfServiceAgreed: Bool,
        privacyPolicyAgreed: Bool,
        isOver14: Bool,
        eventPushAgreed: Bool
    ) async throws {
        try await context.perform {
            let member = try self.fetchMember()
            
            let terms = member.term ?? Terms(context: self.context)
            let now = Date.now
            
            terms.termsOfServiceAgreed = termsOfServiceAgreed
            terms.privacyPolicyAgreed = privacyPolicyAgreed
            terms.isOverFourteen = isOver14
            terms.eventPushAgreed = eventPushAgreed
            terms.updatedAt = now
            
            if member.term == nil {
                terms.id = AutoCounter.getNextID(for: Terms.self, in: self.context)
                terms.createdAt = now
                member.term = terms
            }
            
            try self.context.save()
            
            let _ = self.userDefaultsService.save(true, key: .isAgreedTerms)
        }
    }
    
    func updateAgreementTerm(eventPushAgreed: Bool) async throws {
        try await context.perform {
            let member = try self.fetchMember()
            
            guard let terms = member.term else {
                throw BeforeGoingError.termsNotFound
            }
            
            terms.eventPushAgreed = eventPushAgreed
            terms.updatedAt = .now
            
            try self.context.save()
        }
    }
    
    private func fetchMember() throws -> Member {
        guard let userID: Int = userDefaultsService.load(key: .userID) else {
            throw BeforeGoingError.userIDNotFound
        }
        
        let request = Member.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", userID)
        request.fetchLimit = 1
        
        guard let member = try context.fetch(request).first else {
            throw BeforeGoingError.memberNotFound
        }
        
        return member
    }
}
