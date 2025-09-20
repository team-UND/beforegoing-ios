//
//  GetMemberNameUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/18/25.
//

struct GetMemberNameUseCase {
    
    private let repository: MemberInterface
    
    init(repository: MemberInterface) {
        self.repository = repository
    }
    
    func execute() -> String {
        let name = repository.getMemberName() ?? ""
        return name
    }
}
