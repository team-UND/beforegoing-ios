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
    
    enum Input {
        case nextButtonDidTap
        case initTerms
    }
    
    typealias Output = AgreeItemOutput
    
    struct TermsOutput: AgreeItemOutput {
        let agreeTermsResult: Bool
    }
    
    struct EmptyOutput: AgreeItemOutput {}
    
    init(sendAgreeUseCase: SendAgreeTermsType) {
        self.sendAgreeUseCase = sendAgreeUseCase
        
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
