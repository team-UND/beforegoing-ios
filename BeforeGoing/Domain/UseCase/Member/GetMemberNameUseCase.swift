//
//  GetMemberNameUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/18/25.
//

protocol GetMemberNameType {
    func execute() -> String
}

struct GetMemberNameUseCase: GetMemberNameType {
    
    private let repository: MemberInterface
    
    init(repository: MemberInterface) {
        self.repository = repository
    }
    
    func execute() -> String {
        let name = repository.getMemberName() ?? ""
        return name
    }
}

struct MockGetMemberNameUseCase: GetMemberNameType {
    func execute() -> String {
        return "mock name"
    }
}
