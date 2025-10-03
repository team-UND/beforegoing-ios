//
//  UpdateNicknameUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

protocol UpdateNicknameType {
    
    func execute(nickname: String) async throws
}

struct UpdateNicknameUseCase: UpdateNicknameType {
    
    private let repository: MemberInterface
    
    init(repository: MemberInterface) {
        self.repository = repository
    }
    
    func execute(nickname: String) async throws {
        try await repository.updateNickname(nickname: nickname)
    }
}

struct MockUpdateNicknameUseCase: UpdateNicknameType {
    
    func execute(nickname: String) {}
}
