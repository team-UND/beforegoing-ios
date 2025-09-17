//
//  SettingViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

final class SettingViewModel: ViewModeling {
    
    private let useCase: UpdatePushNoticeUseCase
    
    init(useCase: UpdatePushNoticeUseCase) {
        self.useCase = useCase
    }
    
    enum Input {
        case switchButtonDidTap(Bool)
    }
    
    enum Output {
        case eventPushAgreedResult(Bool)
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .switchButtonDidTap(let eventPushAgreed):
            do {
                try await useCase.execute(eventPushAgreed: eventPushAgreed)
                return .eventPushAgreedResult(true)
            } catch (let error) {
                BeforeGoingLogger.error(error)
                return .eventPushAgreedResult(false)
            }
        }
    }
}
