//
//  AuthStorage.swift
//  BeforeGoing
//
//  Created by APPLE on 3/12/26.
//

import CoreData

struct AuthStorage: AuthInterface {
    
    private let userDefaultsService: UserDefaultsService
    private let context: NSManagedObjectContext
    private let memberStorage: MemberStorage
    
    init(
        userDefaultsService: UserDefaultsService,
        context: NSManagedObjectContext,
        memberStorage: MemberStorage
    ) {
        self.userDefaultsService = userDefaultsService
        self.context = context
        self.memberStorage = memberStorage
    }
    
    func login() async throws -> Bool {
        guard let _: Int = userDefaultsService.load(key: .userID) else {
            let memberID = AutoCounter.getNextID(for: Member.self, in: context)
            let _ = userDefaultsService.save(memberID, key: .userID)
            try await memberStorage.setMember(userID: memberID)
            
            return false
        }
        return true
    }
}
