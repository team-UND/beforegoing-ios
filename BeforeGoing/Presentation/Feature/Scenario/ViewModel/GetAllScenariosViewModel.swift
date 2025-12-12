//
//  GetAllScenariosViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 12/4/25.
//

final class GetAllScenariosViewModel: ViewModeling {
    
    private let fetchScenariosUseCase: FetchScenariosType
    private var scenarios: [ScenarioEntity]?
    private var pointer = 0
    
    init(fetchScenariosUseCase: FetchScenariosType) {
        self.fetchScenariosUseCase = fetchScenariosUseCase
    }
    
    enum Input {
        case requestScenarios
    }
    
    struct Output {
        let scenariosResult: Result<[ScenarioEntity], Error>
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .requestScenarios:
            do {
                let result = try await fetchScenariosUseCase.execute()
                if result.isEmpty {
                    return .init(scenariosResult: .failure(BeforeGoingError.notFoundError))
                }
                self.scenarios = result
                return .init(scenariosResult: .success(result))
            } catch (let error) {
                BeforeGoingLogger.error(error)
                return .init(scenariosResult: .failure(error))
            }
        }
    }
}

extension GetAllScenariosViewModel {
    
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
    
    func findTagByTitle(_ title: String) -> Int {
        scenarios?.firstIndex(where: { $0.scenarioName == title }) ?? 0
    }
}
