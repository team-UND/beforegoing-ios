//
//  NicknameViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

final class NicknameViewModel: ViewModeling {
    
    private let useCase: UpdateNicknameUseCase
    
    init(useCase: UpdateNicknameUseCase) {
        self.useCase = useCase
    }
    
    enum Input {
        case startButtonDidTap(nickname: String)
    }
    
    enum Output {
        case updateNicknameResult(Bool)
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .startButtonDidTap(let nickname):
            do {
                try await useCase.execute(nickname: nickname)
                return .updateNicknameResult(true)
            } catch (let error) {
                BeforeGoingLogger.error(error)
                return .updateNicknameResult(false)
            }
        }
    }
}
