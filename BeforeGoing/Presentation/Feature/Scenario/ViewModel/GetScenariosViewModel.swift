//
//  GetScenariosViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

final class GetScenariosViewModel: ViewModeling {
    
    private let useCase: FetchScenariosType
    private var scenarios: [ScenarioEntity]?
    private var pointer = 0
    
    init(useCase: FetchScenariosType) {
        self.useCase = useCase
    }
    
    enum Input {
        case viewWillAppear
    }
    
    struct Output {
        let scenariosResult: Result<[ScenarioEntity], Error>
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .viewWillAppear:
            do {
                let result = try await useCase.execute()
                if result.isEmpty {
                    return Output(scenariosResult: .failure(BeforeGoingError.notFoundError))
                }
                self.scenarios = result
                return Output(scenariosResult: .success(result))
            } catch (let error) {
                BeforeGoingLogger.error(error)
                return Output(scenariosResult: .failure(error))
            }
        }
    }
}

extension GetScenariosViewModel {
    
    var scenariosCount: Int {
        scenarios?.count ?? 0
    }
    
    var firstScenarioID: Int {
        scenarios?.first?.scenarioId ?? 0
    }
    
    var isEmpty: Bool {
        scenariosCount == 0
    }
    
    func getScenarioName(section: Int) -> String {
        scenarios?[section].scenarioName ?? ""
    }
    
    func getScenarioMemo(section: Int) -> String {
        scenarios?[section].memo ?? ""
    }
    
    func removeScenario(at: Int) {
        scenarios?.remove(at: at)
    }
    
    func moveScenario(
        originalAt: Int,
        destinationAt: Int
    ) {
        guard let movedSection = scenarios?.remove(at: originalAt) else {
            return
        }
        scenarios?.insert(movedSection, at: destinationAt)
    }
    
    func getScenarioID() -> Int {
        scenarios?[pointer].scenarioId ?? 0
    }
    
    func getScenarioID(at index: Int) -> Int {
        scenarios?[index].scenarioId ?? 0
    }
    
    func getPreviousScenarioOrder(current: Int) -> Int? {
        if current == 0 {
            return nil
        }
        return scenarios?[current - 1].scenarioOrder
    }
    
    func getNextScenarioOrder(current: Int) -> Int? {
        if current == scenariosCount - 1 {
            return nil
        }
        return scenarios?[current + 1].scenarioOrder
    }
    
    func updateOrder(updates: [NewOrderEntity]) {
        updates.forEach { update in
            if let index = scenarios?.firstIndex(where: { $0.scenarioId == update.id }) {
                scenarios?[index].scenarioOrder = update.newOrder
            }
        }
    }
    
    func sortScenario() {
        scenarios?.sort { $0.scenarioOrder < $1.scenarioOrder }
    }
    
    func updatePointer(to pointer: Int) {
        self.pointer = pointer
    }
    
    private func findScenarioByID(id: Int) -> ScenarioEntity? {
        scenarios?.filter { $0.scenarioId == id }.first
    }
}
