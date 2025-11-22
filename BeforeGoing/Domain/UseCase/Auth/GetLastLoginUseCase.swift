//
//  GetLastLoginUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 11/22/25.
//

protocol GetLastLoginType {
    func execute() -> Provider?
}

struct GetLastLoginUseCase: GetLastLoginType {
    
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute() -> Provider? {
        repository.getLastLogin()
    }
}

struct MockGetLastLoginUseCase: GetLastLoginType {
    func execute() -> Provider? {
        .kakao
    }
}
