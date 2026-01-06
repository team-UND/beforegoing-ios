//
//  SecondAgreeItemViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 8/7/25.
//

protocol AgreeItemOutput {}

final class AgreeItemViewModel: ViewModeling {
    
    private var agreeItems = AgreeItem.allCases
    private var checkBoxStates: [AgreeItem : CheckBoxState] = [:]
    private let sendAgreeUseCase: SendAgreeTermsType
    private let isAppleLoginedUseCase: IsAppleLoginType
    
    enum Input {
        case nextButtonDidTap
        case initTerms
        case checkLoginMethod
    }
    
    typealias Output = AgreeItemOutput
    
    struct TermsOutput: AgreeItemOutput {
        let agreeTermsResult: Bool
    }
    
    struct EmptyOutput: AgreeItemOutput {}
    
    struct IsAppleLoginedOutput: AgreeItemOutput {
        let isAppleLogined: Result<Bool, BeforeGoingError>
    }
    
    init(
        sendAgreeUseCase: SendAgreeTermsType,
        isAppleLoginedUseCase: IsAppleLoginType
    ) {
        self.sendAgreeUseCase = sendAgreeUseCase
        self.isAppleLoginedUseCase = isAppleLoginedUseCase
        
        agreeItems.forEach { checkBoxStates[$0] = .unchecked }
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .nextButtonDidTap:
            do {
                try await sendAgreeUseCase.execute(
                    termsOfServiceAgreed: matchState(item: .isTermsOfServiceAgreed),
                    privacyPolicyAgreed: matchState(item: .isPrivacyPolicyAgreed),
                    isOver14: matchState(item: .isOverFourteen),
                    eventPushAgreed: matchState(item: .isPushAgreed)
                )
                return TermsOutput(agreeTermsResult: true)
            }
            catch(let error) {
                BeforeGoingLogger.error(error)
                return TermsOutput(agreeTermsResult: false)
            }
            
        case .initTerms:
            agreeItems.forEach { checkBoxStates[$0] = .unchecked }
            return EmptyOutput()
            
        case .checkLoginMethod:
            let result = isAppleLoginedUseCase.execute()
            
            switch result {
            case .some(let isAppleLogined):
                return IsAppleLoginedOutput(isAppleLogined: .success(isAppleLogined))
            case .none:
                return IsAppleLoginedOutput(isAppleLogined: .failure(.notFoundProvider))
            }
        }
    }
}

extension AgreeItemViewModel {
    
    var isAllNecssaryChecked: Bool {
        agreeItems
            .filter { $0.component.isNecessary }
            .allSatisfy { checkBoxStates[$0] == .checked }
    }
    
    var isAllChecked: Bool {
        agreeItems
            .allSatisfy { checkBoxStates[$0] == .checked }
    }
    
    func getState(item: AgreeItem) -> CheckBoxState {
        return checkBoxStates[item] ?? .unchecked
    }
    
    func toggleAllItems(checkBoxState: CheckBoxState) {
        agreeItems.forEach { checkBoxStates[$0] = checkBoxState }
    }
    
    func toggleItem(item: AgreeItem, checkBoxState: CheckBoxState) {
        checkBoxStates[item] = checkBoxState
    }
    
    private func matchState(item: AgreeItem) -> Bool {
        let state = getState(item: item)
        return (state == .checked) ? true : false
    }
}
