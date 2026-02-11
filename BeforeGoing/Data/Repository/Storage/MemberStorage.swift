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
    
    var memberEntity: NSEntityDescription? {
        NSEntityDescription.entity(forEntityName: EntityName.member.string, in: context)
    }
    
    init(
        userDefaultsService: UserDefaultsProtocol,
        context: NSManagedObjectContext = CoreDataStack.shared.newBackgroundContext()
    ) {
        self.userDefaultsService = userDefaultsService
        self.context = context
    }
    
    func updateNickname(nickname: String) async throws {
        try await context.perform { [weak self] in
            guard let self else {
                return
            }
            
            guard let member = try getMember() else {
                return
            }
            
            member.nickname = nickname
            
            if context.hasChanges {
                try context.save()
            }
        }
    }
    
    func withdrawMember() async throws {
        try await context.perform { [weak self] in
            guard let self else {
                return
            }
            
            guard let member = try getMember() else {
                return
            }
            
            context.delete(member)
            
            if context.hasChanges {
                do {
                    try self.context.save()
                    let _ = userDefaultsService.delete(key: .userID)
                } catch {
                    throw error
                }
            }
        }
    }
    
    func getMemberName() async throws -> MemberNameEntity {
        try await context.perform { [weak self] in
            guard let self else {
                return .stub()
            }
            
            guard let member = try getMember() else {
                return .stub()
            }
            
            guard let memberName = member.nickname else {
                return .stub()
            }
            
            return .init(memberName: memberName)
        }
    }
    
    private func getMember() throws -> Member? {
        guard let userID: UUID = userDefaultsService.load(key: .userID) else {
            return nil
        }
                
        let request = Member.fetchRequest()
        request.predicate = NSPredicate(format: "memberId == %@", userID as NSUUID)
        
        let member = try context.fetch(request).first
        
        return member
    }
}
