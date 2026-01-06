//
//  IsAppleLoginedUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 1/6/26.
//

protocol IsAppleLoginType {
    
    func execute() -> Bool?
}

struct IsAppleLoginedUseCase: IsAppleLoginType {
    
    private let repository: MemberInterface
    
    init(repository: MemberInterface) {
        self.repository = repository
    }
    
    func execute() -> Bool? {
        repository.isAppleLogined
    }
}
