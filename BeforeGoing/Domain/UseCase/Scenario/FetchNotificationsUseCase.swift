//
//  FetchNotificationsUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 12/3/25.
//

protocol FetchNotificationsType {
    func execute() async throws -> NotificationsEntity
}

struct FetchNotificationsUseCase: FetchNotificationsType {
    
    private let repository: ScenarioInterface
    
    init(repository: ScenarioInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> NotificationsEntity {
        try await repository.fetchNotifications()
    }
}

struct MockFetchNotificationsUseCase: FetchNotificationsType {
    
    func execute() -> NotificationsEntity {
        .stub()
    }
}
