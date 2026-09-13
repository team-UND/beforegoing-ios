//
//  MissionStorage.swift
//  BeforeGoing
//
//  Created by APPLE on 2/16/26.
//

import CoreData

final class MissionStorage: MissionInterface {
    
    private let userDefaultsService: UserDefaultsProtocol
    private let context: NSManagedObjectContext
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    init(
        userDefaultsService: UserDefaultsProtocol,
        context: NSManagedObjectContext
    ) {
        self.userDefaultsService = userDefaultsService
        self.context = context
    }
    
    func fetchMissions(
        scenarioID: Int,
        date: String
    ) async throws -> MissionsEntity {
        try await context.perform { [weak self] in
            guard let self else { throw BeforeGoingError.unknownError }
            
            let date = try convertToDate(from: date)
            let missions = try fetchMissions(scenarioID: scenarioID, date: date)
            
            let basicMissions: [BasicMissionEntity] = missions
                .filter { $0.missionType == "basic" }
                .map {
                    BasicMissionEntity(
                        missionId: Int($0.id),
                        content: $0.content ?? "",
                        isChecked: $0.isChecked,
                        missionType: $0.missionType ?? ""
                    )
                }
            
            let todayMissions: [TodayMissionEntity] = missions
                .filter { $0.missionType == "today" }
                .map {
                    TodayMissionEntity(
                        missionId: Int($0.id),
                        content: $0.content ?? "",
                        isChecked: $0.isChecked,
                        missionType: $0.missionType ?? ""
                    )
                }
            
            return MissionsEntity(
                scenarioId: scenarioID,
                basicMissions: basicMissions,
                todayMissions: todayMissions
            )
        }
    }

    func checkMission(
        missionID: Int,
        date: String,
        isChecked: Bool
    ) async throws {
        try await context.perform { [weak self] in
            guard let self else { throw BeforeGoingError.unknownError }
            
            let mission = try fetchMission(missionID: missionID)
            mission.isChecked = isChecked
            mission.updatedAt = Date()
            
            try context.save()
        }
    }

    func addTodayMission(
        scenarioID: Int,
        date: String,
        content: String
    ) async throws -> TodayMissionEntity {
        try await context.perform { [weak self] in
            guard let self else { throw BeforeGoingError.unknownError }
            
            let date = try convertToDate(from: date)
            let scenario = try fetchScenario(scenarioID: scenarioID)
            
            let mission = Mission(context: context)
            mission.id = AutoCounter.getNextID(for: Mission.self, in: context)
            mission.content = content
            mission.isChecked = false
            mission.missionType = "today"
            mission.missionOrder = 0
            mission.useDate = date
            mission.createdAt = Date()
            mission.updatedAt = Date()
            mission.scenario = scenario
            
            try context.save()
            
            return TodayMissionEntity(
                missionId: Int(mission.id),
                content: content,
                isChecked: false,
                missionType: "today"
            )
        }
    }

    func deleteTodayMission(missionID: Int) async throws {
        try await context.perform { [weak self] in
            guard let self else { throw BeforeGoingError.unknownError }
            
            let mission = try fetchMission(missionID: missionID)
            
            guard mission.missionType == "today" else {
                throw BeforeGoingError.invalidMissionType
            }
            
            context.delete(mission)
            try context.save()
        }
    }
}

// MARK: private method - Fetch

extension MissionStorage {
    
    private func fetchMission(missionID: Int) throws -> Mission {
        let request = Mission.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", missionID)
        
        guard let mission = try context.fetch(request).first else {
            throw BeforeGoingError.missionNotFound
        }
        
        return mission
    }
    
    private func fetchMissions(scenarioID: Int, date: Date) throws -> [Mission] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            throw BeforeGoingError.unknownError
        }
        
        let request = Mission.fetchRequest()
        request.predicate = NSPredicate(
            format: "scenario.id == %d AND useDate >= %@ AND useDate < %@",
            scenarioID,
            startOfDay as NSDate,
            endOfDay as NSDate
        )
        
        return try context.fetch(request)
    }
    
    private func fetchScenario(scenarioID: Int) throws -> Scenario {
        let request = Scenario.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", scenarioID)
        
        guard let scenario = try context.fetch(request).first else {
            throw BeforeGoingError.scenarioNotFound
        }
        
        return scenario
    }
}

// MARK: private method - Convert

extension MissionStorage {
    
    private func convertToDate(from dateString: String) throws -> Date {
        guard let date = dateFormatter.date(from: dateString) else {
            throw BeforeGoingError.invalidDateFormat
        }
        return date
    }
}
