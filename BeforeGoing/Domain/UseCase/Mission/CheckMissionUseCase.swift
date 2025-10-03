//
//  CheckMissionUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/29/25.
//

protocol CheckMissionType {
    func execute(missionID: Int, date: String, isChecked: Bool) async throws
}

struct CheckMissionUseCase: CheckMissionType {
    
    private let repository: MissionInterface
    
    init(repository: MissionInterface) {
        self.repository = repository
    }
    
    func execute(missionID: Int, date: String, isChecked: Bool) async throws {
        try await repository.checkMission(
            missionID: missionID,
            date: date,
            isChecked: isChecked
        )
    }
}

struct MockCheckMissionUseCase: CheckMissionType {
    
    func execute(missionID: Int, date: String, isChecked: Bool) {}
}
