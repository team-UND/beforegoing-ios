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
    private let userDefaultsService: UserDefaultsProtocol = MockuserDefaultsService()
    private let memberRepository: MemberInterface
    private let getMemberNamseUseCase: GetMemberNameUseCase
    private let updateNickNameUseCase: UpdateNicknameUseCase
    private let memberWithdrawUseCase: MemberWithdrawUseCase
    
    init() {
        self.context = ContextProvider.createMockContext()
        self.memberRepository = MemberStorage(userDefaultsService: userDefaultsService, context: context)
        self.getMemberNamseUseCase = GetMemberNameUseCase(repository: memberRepository)
        self.updateNickNameUseCase = UpdateNicknameUseCase(repository: memberRepository)
        self.memberWithdrawUseCase = MemberWithdrawUseCase(repository: memberRepository)
    }
    
    @Test("유저 이름 조회", arguments: ["test"])
    func getMemberName_success(name: String) async throws {
        // give
        let memberID = UUID()
        let _ = userDefaultsService.save(memberID, key: .userID)
        let member = Member(context: context)
        member.setValue(memberID, forKey: "memberId")
        member.setValue(name, forKey: "nickname")
        member.setValue(Date.now, forKey: "createdAt")
        member.setValue(Date.now, forKey: "updatedAt")
        try context.save()
        
        // when
        let memberName = try await getMemberNamseUseCase.execute()
        
        // then
        #expect(memberName == name)
        let _ = userDefaultsService.delete(key: .userID)
    }
    
    @Test("유저 이름 업데이트", arguments: ["user"])
    func updateMemberName_success(name: String) async throws {
        // give
        let memberID = UUID()
        let _ = userDefaultsService.save(memberID, key: .userID)
        let member = Member(context: context)
        member.setValue(memberID, forKey: "memberId")
        member.setValue(name, forKey: "nickname")
        member.setValue(Date.now, forKey: "createdAt")
        member.setValue(Date.now, forKey: "updatedAt")
        try context.save()
        
        // when
        let _ = try await updateNickNameUseCase.execute(nickname: name)
        
        // then
        #expect(member.nickname == name)
        let _ = userDefaultsService.delete(key: .userID)
    }
    
    @Test("유저 탈퇴")
    func withdrawMemberName_success() async throws {
        // give
        let memberID = UUID()
        let _ = userDefaultsService.save(memberID, key: .userID)
        let member = Member(context: context)
        member.setValue(memberID, forKey: "memberId")
        member.setValue("nickname", forKey: "nickname")
        member.setValue(Date.now, forKey: "createdAt")
        member.setValue(Date.now, forKey: "updatedAt")
        try context.save()
        
        // when
        try await memberWithdrawUseCase.execute()
        
        // then
        let fetchRequest = Member.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "memberId == %@", memberID as NSUUID)
        let remainingMembers = try context.fetch(fetchRequest)

        #expect(remainingMembers.isEmpty)
    }
}
