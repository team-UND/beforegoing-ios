//
//  MemberStorage.swift
//  BeforeGoing
//
//  Created by APPLE on 2/5/26.
//

import CoreData
import Foundation

final class MemberStorage: MemberInterface {
    
    private let userDefaultsService: UserDefaultsProtocol
    private let context: NSManagedObjectContext
    
    init(
        userDefaultsService: UserDefaultsProtocol,
        context: NSManagedObjectContext
    ) {
        self.userDefaultsService = userDefaultsService
        self.context = context
    }
    
    func updateNickname(nickname: String) async throws {
        try await context.perform { [weak self] in
            guard let self,
                  let member = try getMember()
            else {
                throw BeforeGoingError.memberNotFound
            }
            
            member.nickname = nickname
            
            try context.save()
        }
    }
    
    func withdrawMember() async throws {
        try await context.perform { [weak self] in
            guard let self,
                  let member = try getMember() else {
                throw BeforeGoingError.memberNotFound
            }
            
            context.delete(member)
            
            try self.context.save()
            let _ = userDefaultsService.delete(key: .userID)
        }
    }
    
    func getMemberName() async throws -> MemberNameEntity {
        try await context.perform { [weak self] in
            guard let self,
                  let member = try getMember(),
                  let memberName = member.nickname else {
                throw BeforeGoingError.memberNotFound
            }
            
            return .init(memberName: memberName)
        }
    }
    
    private func getMember() throws -> Member? {
        guard let userID: Int = userDefaultsService.load(key: .userID) else {
            return nil
        }
                
        let request = Member.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", userID)
        
        let member = try context.fetch(request).first
        return member
    }
}
