//
//  ScenarioViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

protocol ScenarioOutput {}

final class AddScenarioViewModel: ViewModeling {
    
    private var scenarioName: String?
    private var memo: String?
    private var basicMissions: [String]?
    private var daysOfWeek: [Int]?
    private var startHour: Int?
    private var startMinute: Int?
    
    private let addScenarioUseCase: AddScenarioType
    
    init(addScenarioUseCase: AddScenarioType) {
        self.addScenarioUseCase = addScenarioUseCase
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
                let result = try await addScenarioUseCase.execute(
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
                let result = try await addScenarioUseCase.execute(
                    scenarioName: scenarioName,
                    memo: memo,
                    basicMissions: basicMissions,
                    isNotificationActive: true,
                    noticeMethodType: noticeMethodType.rawValue,
                    daysOfWeekOrdinal: daysOfWeek,
                    startHour: startHour,
                    startMinute: startMinute
                )
                return AddScenarioOutput(addScenarioResult: result)
            } catch {
                BeforeGoingLogger.error(error)
                return EmptyOutput()
            }
        }
    }
}
