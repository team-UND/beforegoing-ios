//
//  MemberUseCaseTest.swift
//  BeforeGoing
//
//  Created by APPLE on 2/5/26.
//

import CoreData
import Testing
@testable import BeforeGoing

struct MemberUseCaseTest {
    
    private let context: NSManagedObjectContext
    private let userDefaultsService: MockUserDefaultsService
    private let memberRepository: MemberInterface
    private let getMemberNamseUseCase: GetMemberNameUseCase
    private let updateNickNameUseCase: UpdateNicknameUseCase
    private let memberWithdrawUseCase: MemberWithdrawUseCase
    
    init() {
        self.context = ContextProvider.makeMockContext()
        self.userDefaultsService = .init()
        self.memberRepository = MemberStorage(userDefaultsService: userDefaultsService, context: context)
        self.getMemberNamseUseCase = .init(repository: memberRepository)
        self.updateNickNameUseCase = .init(repository: memberRepository)
        self.memberWithdrawUseCase = .init(repository: memberRepository)
    }
    
    @Test("유저 이름 조회", arguments: ["test"])
    func getMemberName(nickname: String) async throws {
        // give
        let _ = try await createMember(id: 1, nickname: nickname)
        
        // when
        let memberName = try await getMemberNamseUseCase.execute()
        
        // then
        #expect(memberName == nickname)
    }
    
    @Test("유저 이름 업데이트", arguments: ["user"])
    func updateMemberName(nickname: String) async throws {
        // give
        let _ = try await createMember(id: 1, nickname: "test")
        
        // when
        let _ = try await updateNickNameUseCase.execute(nickname: nickname)
        
        // then
        let memberName = try await getMemberNamseUseCase.execute()
        #expect(memberName == nickname)
    }
    
    @Test("유저 탈퇴")
    func withdrawMemberName() async throws {
        // give
        let _ = try await createMember(id: 1, nickname: "test")
        
        // when
        try await memberWithdrawUseCase.execute()
        
        // then
        let fetchRequest = Member.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", 1)
        let member = try context.fetch(fetchRequest)

        #expect(member.isEmpty)
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
