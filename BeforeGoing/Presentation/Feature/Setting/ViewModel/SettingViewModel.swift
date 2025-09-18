//
//  SettingViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

protocol SettingOutput {}

final class SettingViewModel: ViewModeling {
    
    private let fetchAgreeTermsUseCase: FetchAgreeTermsUseCase
    private let updatePushNoticeUseCase: UpdatePushNoticeUseCase
    
    init(fetchAgreeTermsUseCase: FetchAgreeTermsUseCase, updatePushNoticeUseCase: UpdatePushNoticeUseCase) {
        self.fetchAgreeTermsUseCase = fetchAgreeTermsUseCase
        self.updatePushNoticeUseCase = updatePushNoticeUseCase
    }
    
    enum Input {
        case viewWillAppear
        case switchButtonDidTap(Bool)
    }
    
    typealias Output = SettingOutput
    
    struct EventPushAgreedOutput: SettingOutput {
        let isEventPushAgreed: Result<Bool, BeforeGoingError>
    }
    
    struct UpdatePushNoticeOutput: SettingOutput {
        let updatePushNoticeResult: Result<Void, BeforeGoingError>
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .viewWillAppear:
            do {
                let result = try await fetchAgreeTermsUseCase.execute()
                guard let eventPushAgreed = result?.eventPushAgreed else {
                    return EventPushAgreedOutput(isEventPushAgreed: .failure(.eventPushAgreedNotFound))
                }
                return EventPushAgreedOutput(isEventPushAgreed: .success(eventPushAgreed))
            }
        case .switchButtonDidTap(let eventPushAgreed):
            do {
                try await updatePushNoticeUseCase.execute(eventPushAgreed: eventPushAgreed)
                return UpdatePushNoticeOutput(updatePushNoticeResult: .success(()))
            } catch (let error) {
                BeforeGoingLogger.error(error)
                return UpdatePushNoticeOutput(updatePushNoticeResult: .failure(.updatePushAgreedFailed))
            }
        }
    }
}
