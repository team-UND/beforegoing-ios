//
//  ModifyNicknameViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/18/25.
//

final class ModifyNicknameViewModel: ViewModeling {
    
    private let useCase: UpdateNicknameType
    
    init(useCase: UpdateNicknameType) {
        self.useCase = useCase
    }
    
    enum Input {
        case confirmButtonDidTap(nickname: String)
    }
    
    enum Output {
        case updateNicknameResult(Bool)
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .confirmButtonDidTap(let nickname):
            do {
                try await useCase.execute(nickname: nickname)
                return .updateNicknameResult(true)
            } catch(let error) {
                BeforeGoingLogger.error(error)
                return .updateNicknameResult(false)
            }
        }
    }
}
