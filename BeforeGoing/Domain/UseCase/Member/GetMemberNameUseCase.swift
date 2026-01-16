//
//  GetMemberNameUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/18/25.
//

protocol GetMemberNameType {
    func execute() async throws -> String
}

struct GetMemberNameUseCase: GetMemberNameType {
    
    private let repository: MemberInterface
    
    init(repository: MemberInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> String {
        let result = try await repository.getMemberName()
        return result.memberName
    }
}

struct MockGetMemberNameUseCase: GetMemberNameType {
    func execute() -> String {
        return "mock name"
    }
}
