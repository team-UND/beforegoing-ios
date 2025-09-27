//
//  GetSingleScenarioViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

struct GetSingleScenarioViewModel: ViewModeling {
    
    private let useCase: FetchSingleScenarioType
    
    init(useCase: FetchSingleScenarioType) {
        self.useCase = useCase
    }
    
    enum Input {
        case scenarioListItemCellDidTap(scenarioID: Int)
    }
    
    struct Output {
        let getScenarioResult: Result<ScenarioWithNotificationEntity, Error>
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .scenarioListItemCellDidTap(let scenarioID):
            do {
                let result = try await useCase.execute(scenarioID: scenarioID)
                return .init(getScenarioResult: .success(result))
            } catch {
                BeforeGoingLogger.error(error)
                return .init(getScenarioResult: .failure(error))
            }
        }
    }
}
