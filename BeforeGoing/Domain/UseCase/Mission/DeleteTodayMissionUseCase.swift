//
//  DeleteTodayMissionUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 10/1/25.
//

protocol DeleteTodayMissionType {
    func execute(missionID: Int) async throws
}

struct DeleteTodayMissionUseCase: DeleteTodayMissionType {
    
    private let repository: MissionInterface
    
    init(repository: MissionInterface) {
        self.repository = repository
    }
    
    func execute(missionID: Int) async throws {
        try await repository.deleteTodayMission(missionID: missionID)
    }
}
