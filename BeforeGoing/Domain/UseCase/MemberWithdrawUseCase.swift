//
//  MemberWithdrawUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/18/25.
//

struct MemberWithdrawUseCase {
    
    private let repository: MemberInterface
    
    init(repository: MemberInterface) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.withdrawMember()
    }
}
