//
//  GetScenariosViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

protocol GetScenariosOutput {}

final class GetScenariosViewModel: ViewModeling {
    
    private let fetchScenariosUseCase: FetchScenariosType
    private let fetchNotificationsUseCase: FetchNotificationsType
    private var scenarios: [ScenarioEntity]?
    private var scenariosModel = ScenariosModel()
    private var pointer = 0
    
    init(
        fetchScenariosUseCase: FetchScenariosType,
        fetchNotificationsUseCase: FetchNotificationsType
    ) {
        self.fetchScenariosUseCase = fetchScenariosUseCase
        self.fetchNotificationsUseCase = fetchNotificationsUseCase
    }
    
    enum Input {
        case requestScenarios
        case requestNotifications
    }
    
    typealias Output = GetScenariosOutput
    
    struct ScenariosOutput: GetScenariosOutput {
        let scenariosResult: Result<[ScenarioEntity], Error>
    }
    
    struct NotificationsOutput: GetScenariosOutput {
        let notificationsResult: Result<NotificationsEntity, Error>
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .requestScenarios:
            do {
                let result = try await fetchScenariosUseCase.execute()
                if result.isEmpty {
                    return ScenariosOutput(scenariosResult: .failure(BeforeGoingError.notFoundError))
                }
                self.scenarios = result
                return ScenariosOutput(scenariosResult: .success(result))
            } catch (let error) {
                BeforeGoingLogger.error(error)
                return ScenariosOutput(scenariosResult: .failure(error))
            }
            
        case .requestNotifications:
            do {
                let result = try await fetchNotificationsUseCase.execute()
                createScenarios(notifications: result.notifications)
                return NotificationsOutput(notificationsResult: .success(result))
            } catch (let error) {
                return NotificationsOutput(notificationsResult: .failure(error))
            }
        }
    }
    
    private func createScenarios(notifications: [NotificationEntity]) {
        if let scenarios {
            scenariosModel.removeAll()
            for i in 0..<scenarios.count {
                let scenario = scenarios[i]
                if let notification = notifications.first(where: { $0.scenarioID == scenario.scenarioId }) {
                    let scenarioModel: ScenarioModel = .init(
                        scenarioID: scenario.scenarioId,
                        scenarioName: scenario.scenarioName,
                        scenarioOrder: scenario.scenarioOrder,
                        notificationMethodType: notification.notificationMethodType,
                        daysOfWeek: notification.daysOfWeekOrdinal,
                        startHour: notification.notificationCondition.startHour,
                        startMinute: notification.notificationCondition.startMinute
                    )
                    scenariosModel.append(scenarioModel)
                } else {
                    let scenarioModel: ScenarioModel = .init(
                        scenarioID: scenario.scenarioId,
                        scenarioName: scenario.scenarioName,
                        scenarioOrder: scenario.scenarioOrder
                    )
                    scenariosModel.append(scenarioModel)
                }
            }
        }
    }
}

extension GetScenariosViewModel {
    
    var scenariosCount: Int {
        scenariosModel.scenarios.count
    }
    
    var firstScenarioID: Int {
        scenarios?.first?.scenarioId ?? 0
    }
    
    var isEmpty: Bool {
        scenariosCount == 0
    }
    
    func getScenarioName(section: Int) -> String {
        scenariosModel.scenarios[section].scenarioName
    }
    
    func getScenarioNames() -> [String] {
        scenariosModel.scenarios.map { $0.scenarioName }
    }
    
    func getNotificationInformation(section: Int) -> String? {
        scenariosModel.getNotificationInformation(section: section)
    }
    
    func removeScenario(at: Int) {
        scenariosModel.scenarios.remove(at: at)
    }
    
    func moveScenario(
        originalAt: Int,
        destinationAt: Int
    ) {
        let movedSection = scenariosModel.scenarios.remove(at: originalAt)
        scenariosModel.scenarios.insert(movedSection, at: destinationAt)
    }
    
    func getScenarioID() -> Int {
        scenariosModel.scenarios[pointer].scenarioID
    }
    
    func getScenarioID(at index: Int) -> Int {
        scenariosModel.scenarios[index].scenarioID
    }
        
    func getPreviousScenarioOrder(current: Int) -> Int? {
        if current == 0 {
            return nil
        }
        return scenariosModel.scenarios[current - 1].scenarioOrder
    }
    
    func getNextScenarioOrder(current: Int) -> Int? {
        if current == scenariosCount - 1 {
            return nil
        }
        return scenariosModel.scenarios[current + 1].scenarioOrder
    }
    
    func updateOrder(updates: [NewOrderEntity]) {
        updates.forEach { update in
            if let index = scenariosModel.scenarios.firstIndex(where: { $0.scenarioID == update.id }) {
                scenariosModel.scenarios[index].scenarioOrder = update.newOrder
            }
        }
    }
    
    func sortScenario() {
        scenariosModel.scenarios.sort { $0.scenarioOrder < $1.scenarioOrder }
    }
    
    func updatePointer(to pointer: Int) {
        self.pointer = pointer
    }
    
    func findTagByTitle(_ title: String) -> Int {
        scenariosModel.scenarios.firstIndex(where: { $0.scenarioName == title }) ?? 0
    }
}
