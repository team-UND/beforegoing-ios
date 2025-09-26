//
//  DeleteScenarioViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

final class DeleteScenarioViewModel: ViewModeling {
    
    private let useCase: DeleteScenarioType
    
    init(useCase: DeleteScenarioType) {
        self.useCase = useCase
    }
    
    enum Input {
        case deleteButtonDidTap(scenarioID: Int)
    }
    
    struct Output {
        let deleteScenarioResult: Result<Void, Error>
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .deleteButtonDidTap(let scenarioID):
            do {
                try await useCase.execute(scenarioID: scenarioID)
                return Output(deleteScenarioResult: .success(()))
            } catch {
                BeforeGoingLogger.error(error)
                return Output(deleteScenarioResult: .failure(error))
            }
        }
    }
}
