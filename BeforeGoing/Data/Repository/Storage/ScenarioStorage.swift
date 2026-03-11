//
//  ScenarioStorage.swift
//  BeforeGoing
//
//  Created by APPLE on 2/12/26.
//

import CoreData

final class ScenarioStorage: ScenarioInterface {
    
    private let seperator: String = ","
    private let orderStep = 100
    private let userDefaultService: UserDefaultsProtocol
    private let context: NSManagedObjectContext
    
    init(
        userDefaultService: UserDefaultsProtocol,
        context: NSManagedObjectContext
    ) {
        self.userDefaultService = userDefaultService
        self.context = context
    }
    
    func addScenario(
        scenarioName: String,
        memo: String,
        basicMissions: [String],
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?,
        startHour: Int?,
        startMinute: Int?
    ) async throws -> ScenarioEntity {
        try await context.perform { [weak self] in
            guard let self,
                  let userID: Int = userDefaultService.load(key: .userID) else {
                throw BeforeGoingError.memberNotFound
            }
            
            let member = try fetchMember(userID: userID)
            let maxOrder = try fetchMaxScenarioOrder(member: member)
            let scenario = createScenario(
                userID: userID,
                scenarioName: scenarioName,
                memo: memo,
                maxOrder: maxOrder,
                member: member
            )
            
            basicMissions.forEach {
                self.createMission(content: $0, scenario: scenario)
            }
            
            let notification = self.createNotification(
                isNotificationActive: isNotificationActive,
                noticeMethodType: noticeMethodType,
                daysOfWeekOrdinal: daysOfWeekOrdinal,
                scenario: scenario
            )
            
            if let startHour, let startMinute {
                createTimeNotification(startHour: startHour, startMinute: startMinute, notification: notification)
            }
            
            try context.save()
            
            return .init(
                scenarioId: Int(scenario.id),
                scenarioName: scenarioName,
                memo: memo,
                scenarioOrder: Int(scenario.scenarioOrder)
            )
        }
    }
    
    func fetchScenario(scenarioID: Int) async throws -> ScenarioWithNotificationEntity {
        try await context.perform { [weak self] in
            guard let self else { throw BeforeGoingError.unknownError }
            
            let scenario = try fetchScenario(scenarioID: scenarioID)
            let missions: [MissionEntity] = createMissions(scenario: scenario)
            
            guard let notification = scenario.notification else {
                throw BeforeGoingError.notificationNotFound
            }
            
            let timeNotification = (notification.timeNotifications as? Set<TimeNotification>)?.first
            
            let notificationCondition: NotificationConditionEntity? = timeNotification.map {
                NotificationConditionEntity(
                    notificationType: notification.notificationType ?? "",
                    startHour: Int($0.startHour),
                    startMinute: Int($0.startMinute)
                )
            }
            
            let anyNotification: AnyNotificationEntity = notification.isActive
            ? createActiveNotification(notification: notification)
            : createInactiveNotification(notification: notification)
            
            return .init(
                scenarioID: Int(scenario.id),
                scenarioName: scenario.scenarioName ?? "",
                memo: scenario.memo ?? "",
                basicMissions: missions,
                notification: anyNotification,
                notificationCondition: notificationCondition
            )
        }
    }
    
    func fetchScenarios() async throws -> [ScenarioEntity] {
        try await context.perform { [weak self] in
            guard let self,
                  let userID: Int = userDefaultService.load(key: .userID)
            else {
                throw BeforeGoingError.memberNotFound
            }
            
            let member = try fetchMember(userID: userID)
            let scenarios = try fetchScenarios(member: member)
            
            return scenarios.map {
                .init(
                    scenarioId: Int($0.id),
                    scenarioName: $0.scenarioName ?? "",
                    memo: $0.memo ?? "",
                    scenarioOrder: Int($0.scenarioOrder)
                )
            }
        }
    }
    
    func deleteScenario(scenarioID: Int) async throws {
        try await context.perform { [weak self] in
            guard let self else { return }
            
            let scenario = try fetchScenario(scenarioID: scenarioID)
            
            context.delete(scenario)
            try context.save()
        }
    }
    
    func updateScenario(
        scenarioID: Int,
        scenarioName: String,
        memo: String,
        missions: [(missionID: Int?, content: String)],
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?,
        startHour: Int?,
        startMinute: Int?
    ) async throws -> ScenarioEntity {
        try await context.perform { [weak self] in
            guard let self else { throw BeforeGoingError.unknownError }
            
            let scenario = try fetchScenario(scenarioID: scenarioID)
            
            updateScenario(
                scenario: scenario,
                scenarioName: scenarioName,
                memo: memo
            )
            updateMissions(
                scenario: scenario,
                missions: missions
            )
            let notification = try updateNotification(
                scenario: scenario,
                isNotificationActive: isNotificationActive,
                noticeMethodType: noticeMethodType,
                daysOfWeekOrdinal: daysOfWeekOrdinal
            )
            updateTimeNotification(
                notification: notification,
                startHour: startHour,
                startMinute: startMinute
            )
            
            try context.save()
            
            return ScenarioEntity(
                scenarioId: Int(scenario.id),
                scenarioName: scenarioName,
                memo: memo,
                scenarioOrder: Int(scenario.scenarioOrder)
            )
        }
    }
    
    func updateScenarioOrder(
        scenarioID: Int,
        prevOrder: Int?,
        nextOrder: Int?
    ) async throws -> NewScenarioOrderEntity {
        try await context.perform { [weak self] in
            guard let self,
                  let userID: Int = userDefaultService.load(key: .userID) else {
                throw BeforeGoingError.memberNotFound
            }
            
            let member = try fetchMember(userID: userID)
            let targetScenario = try fetchScenario(scenarioID: scenarioID)
            
            let newOrder: Int = calculateNewOrder(
                prevOrder: prevOrder,
                nextOrder: nextOrder
            )
            let needsReorder = newOrder == prevOrder || newOrder == nextOrder
            
            var orderUpdates: [NewOrderEntity]
            
            if needsReorder {
                orderUpdates = try reorderScenarios(
                    member: member,
                    scenario: targetScenario,
                    nextOrder: nextOrder
                )
            } else {
                orderUpdates = appendNewOrder(
                    scenario: targetScenario,
                    newOrder: newOrder
                )
            }
            
            try context.save()
            
            return .init(
                isReorder: needsReorder,
                orderUpdates: orderUpdates
            )
        }
    }
    
    func fetchNotifications() async throws -> NotificationsEntity {
        try await context.perform { [weak self] in
            guard let self,
                  let userID: Int = userDefaultService.load(key: .userID) else {
                throw BeforeGoingError.memberNotFound
            }
            
            let member = try fetchMember(userID: userID)
            let scenarios = try fetchScenarios(member: member)
            let notificationEntities: [NotificationEntity] = fetchNotificationEntities(scenarios: scenarios)
            
            return NotificationsEntity(notifications: notificationEntities)
        }
    }
}

// MARK: private method - Create Model

extension ScenarioStorage {
    
    private func createScenario(
        userID: Int,
        scenarioName: String,
        memo: String,
        maxOrder: Int,
        member: Member
    ) -> Scenario {
        let scenario = Scenario(context: context)
        scenario.id = AutoCounter.getNextID(for: Scenario.self, in: context)
        scenario.scenarioName = scenarioName
        scenario.memo = memo
        scenario.scenarioOrder = Int64(maxOrder + orderStep)
        scenario.createdAt = Date()
        scenario.updatedAt = Date()
        scenario.member = member
        
        return scenario
    }
    
    private func createMission(
        content: String,
        scenario: Scenario,
        id: Int? = nil
    ) {
        let mission = Mission(context: context)
        mission.id = Int64(id ?? 0)
        mission.content = content
        mission.isChecked = false
        mission.missionType = "basic"
        mission.missionOrder = 0
        mission.useDate = Date()
        mission.createdAt = Date()
        mission.updatedAt = Date()
        mission.scenario = scenario
    }
    
    private func createNotification(
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?,
        scenario: Scenario
    ) -> Notification {
        let notification = Notification(context: context)
        notification.isActive = isNotificationActive
        notification.notificationMethodType = noticeMethodType ?? ""
        notification.notificationType = "push"
        notification.daysOfWeek = daysOfWeekOrdinal?.map { String($0) }.joined(separator: seperator) ?? ""
        notification.createdAt = Date()
        notification.updatedAt = Date()
        notification.scenario = scenario
        
        return notification
    }
    
    private func createTimeNotification(
        startHour: Int,
        startMinute: Int,
        notification: Notification
    ) {
        let timeNotification = TimeNotification(context: context)
        timeNotification.startHour = Int64(startHour)
        timeNotification.startMinute = Int64(startMinute)
        timeNotification.createdAt = Date()
        timeNotification.updatedAt = Date()
        timeNotification.notification = notification
    }
}

// MARK: private method - Create Entity

extension ScenarioStorage {
    
    private func createActiveNotification(notification: Notification) -> AnyNotificationEntity {
        let daysOfWeekOrdinal = notification.daysOfWeek?
            .split(separator: seperator)
            .compactMap { Int($0) } ?? []
        
        return .init(
            active: ActiveNotificationEntity(
                notificationID: Int(notification.id),
                notificationType: notification.notificationType ?? "",
                notificationMethodType: NoticeMethodType(
                    rawValue: notification.notificationMethodType ?? ""
                ) ?? .alarm,
                daysOfWeekOrdinal: daysOfWeekOrdinal
            )
        )
    }
    
    private func createInactiveNotification(notification: Notification) -> AnyNotificationEntity {
        .init(
            inactive: InactiveNotificationEntity(
                notificationID: Int(notification.id),
                notificationType: notification.notificationType ?? ""
            )
        )
    }
    
    private func createMissions(scenario: Scenario) -> [MissionEntity] {
        return (scenario.missions as? Set<Mission>)?.map {
            MissionEntity(
                missionId: Int($0.id),
                content: $0.content ?? "",
                isChecked: $0.isChecked,
                missionType: $0.missionType ?? ""
            )
        } ?? []
    }
}

// MARK: private method - Fetch

extension ScenarioStorage {
    
    private func fetchMember(userID: Int) throws -> Member {
        let memberRequest = Member.fetchRequest()
        memberRequest.predicate = NSPredicate(format: "id == %d", userID)
        guard let member = try context.fetch(memberRequest).first else {
            throw BeforeGoingError.memberNotFound
        }
        
        return member
    }
    
    private func fetchScenario(scenarioID: Int) throws -> Scenario {
        let request = Scenario.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", scenarioID)
        
        guard let scenario = try context.fetch(request).first else {
            throw BeforeGoingError.scenarioNotFound
        }
        
        return scenario
    }
    
    private func fetchScenarios(member: Member) throws -> [Scenario] {
        let request = Scenario.fetchRequest()
        request.predicate = NSPredicate(format: "member == %@", member)
        request.sortDescriptors = [NSSortDescriptor(key: "scenarioOrder", ascending: true)]
        
        let scenarios = try context.fetch(request)
        return scenarios
    }
    
    private func fetchNotificationEntities(scenarios: [Scenario]) -> [NotificationEntity] {
        scenarios.compactMap { scenario in
            guard let notification = scenario.notification,
                  notification.isActive,
                  let notificationType = notification.notificationType,
                  let methodType = notification.notificationMethodType,
                  let timeNotification = (notification.timeNotifications as? Set<TimeNotification>)?.first
            else {
                return nil
            }
            
            let daysOfWeekOrdinal = notification.daysOfWeek?
                .split(separator: self.seperator)
                .compactMap { Int($0) } ?? []
            
            let condition = NotificationConditionEntity(
                notificationType: notificationType,
                startHour: Int(timeNotification.startHour),
                startMinute: Int(timeNotification.startMinute)
            )
            
            return .init(
                scenarioID: Int(scenario.id),
                scenarioName: scenario.scenarioName ?? "",
                memo: scenario.memo ?? "",
                notificationID: Int(notification.id),
                notificationType: notificationType,
                notificationMethodType: methodType,
                daysOfWeekOrdinal: daysOfWeekOrdinal,
                notificationCondition: condition
            )
        }
    }
    
    private func fetchMaxScenarioOrder(member: Member) throws -> Int {
        let scenarios = try fetchScenarios(member: member)
        return scenarios.map { Int($0.scenarioOrder) }.max() ?? 0
    }
}

// MARK: private method - Update

extension ScenarioStorage {
    
    private func updateScenario(
        scenario: Scenario,
        scenarioName: String,
        memo: String
    ) {
        scenario.scenarioName = scenarioName
        scenario.memo = memo
        scenario.updatedAt = Date()
    }
    
    private func updateMissions(
        scenario: Scenario,
        missions: [(missionID: Int?, content: String)]
    ) {
        if let existingMissions = scenario.missions as? Set<Mission> {
            existingMissions.forEach { self.context.delete($0) }
        }
        
        missions.forEach {
            createMission(
                content: $0.content,
                scenario: scenario,
                id: $0.missionID
            )
        }
    }
    
    private func updateNotification(
        scenario: Scenario,
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?
    ) throws -> Notification {
        guard let notification = scenario.notification else {
            throw BeforeGoingError.notificationNotFound
        }
        
        notification.isActive = isNotificationActive
        notification.notificationMethodType = noticeMethodType ?? ""
        notification.daysOfWeek = daysOfWeekOrdinal?.map { String($0) }.joined(separator: seperator) ?? ""
        notification.updatedAt = Date()
        
        return notification
    }
    
    private func updateTimeNotification(
        notification: Notification,
        startHour: Int?,
        startMinute: Int?
    ) {
        if let existing = notification.timeNotifications as? Set<TimeNotification> {
            existing.forEach { self.context.delete($0) }
        }
        
        if let startHour, let startMinute {
            let timeNotification = TimeNotification(context: context)
            timeNotification.startHour = Int64(startHour)
            timeNotification.startMinute = Int64(startMinute)
            timeNotification.createdAt = Date()
            timeNotification.updatedAt = Date()
            timeNotification.notification = notification
        }
    }
}


// MARK: private method - Order

extension ScenarioStorage {
    
    private func calculateNewOrder(prevOrder: Int?, nextOrder: Int?) -> Int {
        switch (prevOrder, nextOrder) {
        case (nil, let next?):
            next - 1
        case (let prev?, nil):
            prev + 1
        case (let prev?, let next?):
            (prev + next) / 2
        case (nil, nil):
            0
        }
    }
    
    private func reorderScenarios(
        member: Member,
        scenario: Scenario,
        nextOrder: Int?
    ) throws -> [NewOrderEntity] {
        var allScenarios = try fetchScenarios(member: member)
        let relocatedScenarios = relocate(
            allScenarios: allScenarios,
            newScenario: scenario,
            nextOrder: nextOrder
        )
        return assignOrder(to: relocatedScenarios)
    }
    
    private func relocate(
        allScenarios: [Scenario],
        newScenario: Scenario,
        nextOrder: Int?
    ) -> [Scenario] {
        var scenarios = allScenarios
        
        scenarios.removeAll { $0.id == newScenario.id }
        let insertIndex = getInsertIndex(allScenarios: scenarios, nextOrder: nextOrder)
        scenarios.insert(newScenario, at: insertIndex)
        
        return scenarios
    }
    
    private func assignOrder(to allScenarios: [Scenario]) -> [NewOrderEntity] {
        var orderUpdates: [NewOrderEntity] = []
        
        for (index, scenario) in allScenarios.enumerated() {
            scenario.scenarioOrder = Int64(index)
            orderUpdates.append(NewOrderEntity(id: Int(scenario.id), newOrder: index))
        }
        
        return orderUpdates
    }
    
    private func getInsertIndex(
        allScenarios: [Scenario],
        nextOrder: Int?
    ) -> Int {
        if let next = nextOrder {
            return allScenarios.firstIndex { Int($0.scenarioOrder) >= next } ?? allScenarios.count
        }
        return allScenarios.count
    }
    
    private func appendNewOrder(scenario: Scenario, newOrder: Int) -> [NewOrderEntity] {
        scenario.scenarioOrder = Int64(newOrder)
        return [NewOrderEntity(id: Int(scenario.id), newOrder: newOrder)]
    }
}
