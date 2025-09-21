//
//  MemberWithdrawUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/18/25.
//

protocol MemberWithdrawType {
    
    func execute() async throws
}

struct MemberWithdrawUseCase: MemberWithdrawType {
    
    private let repository: MemberInterface
    
    init(repository: MemberInterface) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.withdrawMember()
    }
}

struct MockMemberWithdrawUseCase: MemberWithdrawType {
    
    func execute() {}
}
