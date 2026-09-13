//
//  ScenarioUseCaseTest.swift
//  BeforeGoing
//
//  Created by APPLE on 3/4/26.
//

import CoreData
import Testing
@testable import BeforeGoing

struct ScenarioUseCaseTest {
    
    private let context: NSManagedObjectContext
    private let userDefaultsService: MockUserDefaultsService
    private let repository: ScenarioInterface
    private let addScenarioUseCase: AddScenarioUseCase
    private let deleteScenarioUseCase: DeleteScenarioUseCase
    private let fetchNotificationsUseCase: FetchNotificationsUseCase
    private let fetchScenariosUseCase: FetchScenariosUseCase
    private let fetchSingleScenarioUseCase: FetchSingleScenarioUseCase
    private let updateScenarioOrderUseCase: UpdateScenarioOrderUseCase
    private let updateScenarioUseCase: UpdateScenarioUseCase
    
    init() {
        self.context = ContextProvider.makeMockContext()
        self.userDefaultsService = .init()
        self.repository = ScenarioStorage(userDefaultService: userDefaultsService, context: context)
        self.addScenarioUseCase = .init(repository: repository)
        self.deleteScenarioUseCase = .init(repository: repository)
        self.fetchNotificationsUseCase = .init(repository: repository)
        self.fetchScenariosUseCase = .init(repository: repository)
        self.fetchSingleScenarioUseCase = .init(repository: repository)
        self.updateScenarioOrderUseCase = .init(repository: repository)
        self.updateScenarioUseCase = .init(repository: repository)
    }
    
    @Test("시나리오 추가")
    func addScenario_success() async throws {
        try await createMember(id: 1, nickname: "test")
        let scenario = try await addScenarioUseCase
            .execute(
                scenarioName: "scenario",
                memo: "memo",
                basicMissions: ["mission"],
                isNotificationActive: false,
                noticeMethodType: nil,
                daysOfWeekOrdinal: nil,
                startHour: nil,
                startMinute: nil
            )
        
        let fetchedScenario = try await fetchSingleScenarioUseCase.execute(scenarioID: scenario.scenarioId)
        
        #expect(scenario.scenarioId == fetchedScenario.scenarioID)
        #expect(scenario.scenarioName == fetchedScenario.scenarioName)
        #expect(scenario.memo == fetchedScenario.memo)
    }
    
    @Test("시나리오 삭제")
    func deleteScenario_success() async throws {
        try await createMember(id: 1, nickname: "test")
        let scenario = try await addScenarioUseCase
            .execute(
                scenarioName: "scenario",
                memo: "memo",
                basicMissions: ["mission"],
                isNotificationActive: false,
                noticeMethodType: nil,
                daysOfWeekOrdinal: nil,
                startHour: nil,
                startMinute: nil
            )
        
        let _ = try await deleteScenarioUseCase.execute(scenarioID: scenario.scenarioId)
        
        let fetchRequest = Scenario.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", scenario.scenarioId)
        let fetchedScenario = try context.fetch(fetchRequest)
        
        #expect(fetchedScenario.isEmpty)
    }
    
    @Test("알림 조회")
    func fetchNotifications() async throws {
        let scenarioName = "scenario"
        let memo = "memo"
        let basicMissions = ["mission"]
        let notificationMethodType = "push"
        let daysOfWeekOrdinal = [0, 1, 2]
        let startHour = 1
        let startMinute = 15
        
        try await createMember(id: 1, nickname: "test")
        let scenario = try await addScenarioUseCase
            .execute(
                scenarioName: scenarioName,
                memo: memo,
                basicMissions: basicMissions,
                isNotificationActive: true,
                noticeMethodType: notificationMethodType,
                daysOfWeekOrdinal: daysOfWeekOrdinal,
                startHour: startHour,
                startMinute: startMinute
            )
        
        let notificationsEntity = try await fetchNotificationsUseCase.execute()
        let notification = notificationsEntity.notifications.first { scenario.scenarioId == $0.scenarioID }
        
        #expect(notification?.scenarioName == scenarioName)
        #expect(notification?.memo == memo)
        #expect(notification?.notificationMethodType == notificationMethodType)
        #expect(notification?.daysOfWeekOrdinal == daysOfWeekOrdinal)
        #expect(notification?.notificationCondition.startHour == startHour)
        #expect(notification?.notificationCondition.startMinute == startMinute)
        #expect(notificationsEntity.notifications.count == 1)
    }
    
    @Test("비활성화된 알림은 조회되지 않음")
    func isNotificationInactive_fetchNotifications_count__zero() async throws {
        try await createMember(id: 1, nickname: "test")
        let _ = try await addScenarioUseCase
            .execute(
                scenarioName: "scenario",
                memo: "memo",
                basicMissions: ["mission"],
                isNotificationActive: false,
                noticeMethodType: nil,
                daysOfWeekOrdinal: nil,
                startHour: nil,
                startMinute: nil
            )
        
        let notificationsEntity = try await fetchNotificationsUseCase.execute()
        #expect(notificationsEntity.notifications.isEmpty)
    }
    
    @Test("시나리오 목록 조회")
    func fetchScenarios() async throws {
        try await createMember(id: 1, nickname: "test")
        for number in [1, 2, 3] {
            let _ = try await addScenarioUseCase
                .execute(
                    scenarioName: "scenario\(number)",
                    memo: "memo",
                    basicMissions: ["mission"],
                    isNotificationActive: false,
                    noticeMethodType: nil,
                    daysOfWeekOrdinal: nil,
                    startHour: nil,
                    startMinute: nil
                )
        }
        
        let fetchedScenarios = try await fetchScenariosUseCase.execute()
        #expect(fetchedScenarios.count == 3)
        #expect(fetchedScenarios[0].scenarioName == "scenario1")
        #expect(fetchedScenarios[1].scenarioName == "scenario2")
        #expect(fetchedScenarios[2].scenarioName == "scenario3")
    }
    
    @Test("시나리오 순서 수정 - 재정렬 필요 없음")
    func updateScenarioOrder_noNeedReorder() async throws {
        try await createMember(id: 1, nickname: "test")
        let scenarios: [ScenarioEntity] = try await createScenarios()
        
        let newOrder = try await updateScenarioOrderUseCase.execute(
            scenarioID: scenarios[2].scenarioId,
            prevOrder: scenarios[0].scenarioOrder,
            nextOrder: scenarios[1].scenarioOrder
        )
        
        #expect(!newOrder.isReorder)
        #expect(newOrder.orderUpdates.count == 1)
        #expect(newOrder.orderUpdates.first?.id == scenarios[2].scenarioId)
        #expect(newOrder.orderUpdates.first?.newOrder == 150)
    }
    
    @Test("시나리오 순서 수정 - 재정렬 필요")
    func updateScenarioOrder_needReorder() async throws {
        try await createMember(id: 1, nickname: "test")
        let scenarios: [ScenarioEntity] = try await createScenarios()
        
        let newOrder = try await updateScenarioOrderUseCase.execute(
            scenarioID: scenarios[0].scenarioId,
            prevOrder: 100,
            nextOrder: 101
        )
        
        #expect(newOrder.isReorder)
        #expect(newOrder.orderUpdates.count == 3)
    }
    
    @Test("시나리오 수정")
    func updateScenario() async throws {
        try await createMember(id: 1, nickname: "test")
        let scenario = try await addScenarioUseCase
            .execute(
                scenarioName: "scenario",
                memo: "memo",
                basicMissions: ["mission"],
                isNotificationActive: false,
                noticeMethodType: nil,
                daysOfWeekOrdinal: nil,
                startHour: nil,
                startMinute: nil
            )
        
        let fetchedScenario = try await fetchSingleScenarioUseCase.execute(scenarioID: scenario.scenarioId)
        
        let updatedScenario = try await updateScenarioUseCase
            .execute(
                scenarioID: scenario.scenarioId,
                scenarioName: "newScenario",
                memo: "newMemo",
                missions: fetchedScenario.basicMissions.map { ($0.missionId, $0.content) },
                isNotificationActive: false,
                noticeMethodType: nil,
                daysOfWeekOrdinal: nil,
                startHour: nil,
                startMinute: nil
            )
        
        #expect(updatedScenario.scenarioName == "newScenario")
        #expect(updatedScenario.memo == "newMemo")
        #expect(updatedScenario.scenarioId == scenario.scenarioId)
        #expect(updatedScenario.scenarioOrder == scenario.scenarioOrder)
    }
}

extension ScenarioUseCaseTest {
    
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
    
    private func createScenarios() async throws -> [ScenarioEntity] {
        var scenarios: [ScenarioEntity] = []
        for number in [1, 2, 3] {
            let scenario = try await addScenarioUseCase
                .execute(
                    scenarioName: "scenario\(number)",
                    memo: "memo",
                    basicMissions: ["mission"],
                    isNotificationActive: false,
                    noticeMethodType: nil,
                    daysOfWeekOrdinal: nil,
                    startHour: nil,
                    startMinute: nil
                )
            
            scenarios.append(scenario)
        }
        
        return scenarios
    }
}
