//
//  UpdateScenarioOrderViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

final class UpdateScenarioOrderViewModel: ViewModeling {
    
    private let useCase: UpdateScenarioOrderType
    
    init(useCase: UpdateScenarioOrderType) {
        self.useCase = useCase
    }
    
    enum Input {
        case scenarioDidDrag(scenarioID: Int, prevOrder: Int?, nextOrder: Int?)
    }
    
    struct Output {
        let updateScenarioOrderResult: Result<NewScenarioOrderEntity, Error>
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .scenarioDidDrag(let scenarioID, let prevOrder, let nextOrder):
            do {
                let result = try await useCase.execute(
                    scenarioID: scenarioID,
                    prevOrder: prevOrder,
                    nextOrder: nextOrder
                )
                return .init(updateScenarioOrderResult: .success(result))
            } catch {
                BeforeGoingLogger.error(error)
                return .init(updateScenarioOrderResult: .failure(error))
            }
        }
    }
}
