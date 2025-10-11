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
    
    struct Output {
        let updateNicknameResult: Result<Void, Error>
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .confirmButtonDidTap(let nickname):
            do {
                try await useCase.execute(nickname: nickname)
                return .init(updateNicknameResult: .success(()))
            } catch(let error) {
                BeforeGoingLogger.error(error)
                return .init(updateNicknameResult: .failure(error))
            }
        }
    }
}
