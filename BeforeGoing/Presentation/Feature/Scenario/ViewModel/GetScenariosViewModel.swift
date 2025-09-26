//
//  GetScenariosViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

final class GetScenariosViewModel: ViewModeling {
    
    private let useCase: FetchScenariosType
    private var scenarios: [ScenarioEntity]?
    
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
                self.scenarios = result
                return Output(scenariosResult: .success(result))
            } catch {
                BeforeGoingLogger.error(error)
                return Output(scenariosResult: .failure(error))
            }
        }
    }
    
    var scenariosCount: Int {
        scenarios?.count ?? 0
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
}
