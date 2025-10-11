//
//  UpdateScenarioViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

protocol UpdateScenarioOutput {}

final class UpdateScenarioViewModel: ViewModeling {
    
    private var scenarioID: Int?
    private var scenarioName: String?
    private var memo: String?
    private var basicMissions: [(missionID: Int?, content: String)]?
    private var daysOfWeek: [Int]?
    private var startHour: Int?
    private var startMinute: Int?
    
    private let useCase: UpdateScenarioType
    
    init(useCase: UpdateScenarioType) {
        self.useCase = useCase
    }
    
    enum Input {
        case nextButtonInSetScenarioDidTap(
            scenarioID: Int,
            scenarioName: String,
            memo: String,
            basicMissions: [(missionID: Int?, content: String)]
        )
        case saveButtonInSetNoticeDidTap
        case nextButtonInSetNoticeDidTap(
            daysOfWeek: [Int],
            startHour: Int?,
            startMinute: Int?
        )
        case saveButtonInSetNoticeMethodDidTap(noticeMethodType: NoticeMethodType)
    }
    
    typealias Output = UpdateScenarioOutput
    
    struct ScenarioOutput: UpdateScenarioOutput {
        let updateScenarioResult: ScenarioEntity
    }
    
    struct EmptyOutput: UpdateScenarioOutput {}
    
    func action(input: Input) async throws -> any Output {
        switch input {
        case .nextButtonInSetScenarioDidTap(let scenarioID, let scenarioName, let memo, let basicMissions):
            self.scenarioID = scenarioID
            self.scenarioName = scenarioName
            self.memo = memo
            self.basicMissions = basicMissions
            
            return EmptyOutput()
            
        case .saveButtonInSetNoticeDidTap:
            guard let scenarioID = scenarioID,
                  let scenarioName = scenarioName,
                  let memo = memo,
                  let basicMissions = basicMissions else {
                return EmptyOutput()
            }
            do {
                let result = try await useCase.execute(
                    scenarioID: scenarioID,
                    scenarioName: scenarioName,
                    memo: memo,
                    missions: basicMissions,
                    isNotificationActive: false,
                    noticeMethodType: nil,
                    daysOfWeekOrdinal: nil,
                    startHour: nil,
                    startMinute: nil
                )
                return ScenarioOutput(updateScenarioResult: result)
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
            guard let scenarioID = scenarioID,
                  let scenarioName = scenarioName,
                  let memo = memo,
                  let basicMissions = basicMissions,
                  let daysOfWeek = daysOfWeek,
                  let startHour = startHour,
                  let startMinute = startMinute else {
                return EmptyOutput()
            }
            do {
                let result = try await useCase.execute(
                    scenarioID: scenarioID,
                    scenarioName: scenarioName,
                    memo: memo,
                    missions: basicMissions,
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
                return ScenarioOutput(updateScenarioResult: result)
            } catch {
                BeforeGoingLogger.error(error)
                return EmptyOutput()
            }
        }
    }
}
