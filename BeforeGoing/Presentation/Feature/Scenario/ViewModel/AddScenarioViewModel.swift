//
//  ScenarioViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

protocol ScenarioOutput {}

final class AddScenarioViewModel: ViewModeling {
    
    private var missions: [(missionID: Int?, content: String)] = []
    private var scenarioName: String?
    private var memo: String?
    private var basicMissions: [String]?
    private var daysOfWeek: [Int]?
    private var startHour: Int?
    private var startMinute: Int?
    
    private let useCase: AddScenarioType
    
    init(useCase: AddScenarioType) {
        self.useCase = useCase
    }
    
    enum Input {
        case nextButtonInSetScenarioDidTap(
            scenarioName: String,
            memo: String,
            basicMissions: [String]
        )
        case saveButtonInSetNoticeDidTap
        case nextButtonInSetNoticeDidTap(
            daysOfWeek: [Int],
            startHour: Int?,
            startMinute: Int?
        )
        case saveButtonInSetNoticeMethodDidTap(noticeMethodType: NoticeMethodType)
    }
    
    typealias Output = ScenarioOutput
    
    struct AddScenarioOutput: ScenarioOutput {
        let addScenarioResult: ScenarioEntity
    }
    
    struct EmptyOutput: ScenarioOutput {}
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .nextButtonInSetScenarioDidTap(let scenarioName, let memo, let basicMissions):
            self.scenarioName = scenarioName
            self.memo = memo
            self.basicMissions = basicMissions
            
            return EmptyOutput()
            
        case .saveButtonInSetNoticeDidTap:
            guard let scenarioName = scenarioName,
                  let memo = memo,
                  let basicMissions = basicMissions else {
                return EmptyOutput()
            }
            
            do {
                let result = try await useCase.execute(
                    scenarioName: scenarioName,
                    memo: memo,
                    basicMissions: basicMissions,
                    isNotificationActive: false,
                    noticeMethodType: nil,
                    daysOfWeekOrdinal: nil,
                    startHour: nil,
                    startMinute: nil
                )
                return AddScenarioOutput(addScenarioResult: result)
            } catch {
                BeforeGoingLogger.error(error)
                return EmptyOutput()
            }
            
        case .nextButtonInSetNoticeDidTap(let daysOfWeek, let startHour, let startMinute):
            self.daysOfWeek = daysOfWeek
            self.startHour = startHour
            self.startMinute = startMinute
            
            return EmptyOutput()
            
        case .saveButtonInSetNoticeMethodDidTap(let noticeMethodType):
            guard let scenarioName = scenarioName,
                  let memo = memo,
                  let basicMissions = basicMissions,
                  let daysOfWeek = daysOfWeek,
                  let startHour = startHour,
                  let startMinute = startMinute else {
                return EmptyOutput()
            }
            do {
                let result = try await useCase.execute(
                    scenarioName: scenarioName,
                    memo: memo,
                    basicMissions: basicMissions,
                    isNotificationActive: true,
                    noticeMethodType: noticeMethodType.rawValue,
                    daysOfWeekOrdinal: daysOfWeek,
                    startHour: startHour,
                    startMinute: startMinute
                )
                
                if let date = DateUtil.createDateFromTime(hour: startHour, minute: startMinute) {
                    let identifier = noticeMethodType.convertIdentifier()
                    
                    NotificationManager.shared.pushDailyNotification(
                        title: "\(scenarioName)",
                        body: "미션을 수행하러 가볼까요?",
                        daysOfWeek: daysOfWeek,
                        date: date,
                        identifier: identifier
                    )
                }
                return AddScenarioOutput(addScenarioResult: result)
            } catch {
                BeforeGoingLogger.error(error)
                return EmptyOutput()
            }
        }
    }
}

extension AddScenarioViewModel {
    
    var missionsCount: Int {
        missions.count
    }
    
    var missionsContent: [String] {
        missions.map { $0.content }
    }
    
    var isExistMission: Bool {
        !missions.isEmpty
    }
    
    func setMissions(missions: [String]) {
        self.missions = missions.map { (nil, $0) }
    }
    
    func setMissions(missions: [(missionID: Int, content: String)]) {
        self.missions = missions.map { ($0.missionID, $0.content) }
    }
    
    func getMissions() -> [(missionID: Int?, content: String)] {
        missions
    }
    
    func addMission(missionContent: String) {
        missions.insert((nil, missionContent), at: 0)
    }
    
    func addMission(_ mission: (Int?, String), at index: Int) {
        missions.insert(mission, at: index)
    }
    
//    func addMissions(missions: [(missionID: Int, content: String)]) {
//        missions.forEach { self.missions.append(($0.missionID, $0.content)) }
//    }
    
    func contains(missionContent: String) -> Bool {
        missions.contains(where: { _, content in
            content == missionContent
        })
    }
    
    func findMissionContent(at index: Int) -> String? {
        guard index >= 0 && index < missions.count else {
            return nil
        }
        return missions[index].content
    }
    
    func removeMission(at index: Int) -> (Int?, String) {
        missions.remove(at: index)
    }
}
