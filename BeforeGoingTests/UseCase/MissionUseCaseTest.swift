//
//  MissionUseCaseTest.swift
//  BeforeGoing
//
//  Created by APPLE on 2/16/26.
//

import CoreData
import Testing
@testable import BeforeGoing

struct MissionUseCaseTest {
    
    private let context: NSManagedObjectContext
    private let userDefaultsService: MockUserDefaultsService
    private let missionRepository: MissionInterface
    private let scenarioRepository: ScenarioInterface
    private let addScenarioUseCase: AddScenarioUseCase
    private let addTodayMissionUseCase: AddTodayMissionUseCase
    private let checkMissionUseCase: CheckMissionUseCase
    private let deleteTodayMissionUseCase: DeleteTodayMissionUseCase
    private let fetchMissionUseCase: FetchMissionsUseCase
    
    init() {
        self.context = ContextProvider.makeMockContext()
        self.userDefaultsService = .init()
        self.missionRepository = MissionStorage(
            userDefaultsService: userDefaultsService,
            context: context
        )
        self.scenarioRepository = ScenarioStorage(
            userDefaultService: userDefaultsService,
            context: context
        )
        self.addScenarioUseCase = .init(repository: scenarioRepository)
        self.addTodayMissionUseCase = .init(repository: missionRepository)
        self.checkMissionUseCase = .init(repository: missionRepository)
        self.deleteTodayMissionUseCase = .init(repository: missionRepository)
        self.fetchMissionUseCase = .init(repository: missionRepository)
    }
    
    @Test("오늘의 미션 추가")
    func addTodayMission() async throws {
        try await createMember(id: 1, nickname: "test")
        let scenario = try await addScenario()
        let todayMission = try await addTodayMission(scenarioID: scenario.scenarioId)
        
        #expect(!todayMission.isChecked)
        #expect(todayMission.content == "content")
        #expect(todayMission.missionType == "today")
    }
    
    @Test("미션 체크", arguments: [true, false])
    func checkMission(isChecked: Bool) async throws {
        try await createMember(id: 1, nickname: "test")
        let scenario = try await addScenario()
        let todayMission = try await addTodayMission(scenarioID: scenario.scenarioId)
        
        try await checkMissionUseCase.execute(
            missionID: todayMission.missionId,
            date: "2026-02-16",
            isChecked: isChecked
        )
        let fetchedMissions = try await fetchMissionUseCase.execute(
            scenarioID: scenario.scenarioId,
            date: "2026-02-16"
        )
        
        let fetchedTodayMission = fetchedMissions.todayMissions.first { todayMission.missionId == $0.missionId }
        #expect(fetchedTodayMission?.isChecked == isChecked)
    }
    
    @Test("미션 삭제")
    func deleteMission() async throws {
        try await createMember(id: 1, nickname: "test")
        let scenario = try await addScenario()
        let todayMission = try await addTodayMission(scenarioID: scenario.scenarioId)
        
        try await deleteTodayMissionUseCase.execute(missionID: todayMission.missionId)
        
        let fetchedMissions = try await fetchMissionUseCase.execute(scenarioID: scenario.scenarioId, date: "2026-02-16")
        let fetchedTodayMission = fetchedMissions.todayMissions.first { todayMission.missionId == $0.missionId }
        
        #expect(fetchedTodayMission == nil)
    }
}

extension MissionUseCaseTest {
    
    private func createMember(id: Int, nickname: String) async throws {
        let _ = userDefaultsService.save(id, key: .userID)
        
        try await context.perform {
            let member = Member(context: self.context)
            member.id = Int64(id)
            member.nickname = nickname
            member.createdAt = .now
            member.updatedAt = .now
            try self.context.save()
        }
    }
    
    private func addScenario() async throws -> ScenarioEntity {
        return try await addScenarioUseCase.execute(
            scenarioName: "scenarioName",
            memo: "memo",
            basicMissions: ["mission"],
            isNotificationActive: false,
            noticeMethodType: nil,
            daysOfWeekOrdinal: nil,
            startHour: nil,
            startMinute: nil
        )
    }
    
    private func addTodayMission(scenarioID: Int) async throws -> TodayMissionEntity {
        return try await addTodayMissionUseCase.execute(
            scenarioID: scenarioID,
            date: "2026-02-16",
            content: "content"
        )
    }
}
