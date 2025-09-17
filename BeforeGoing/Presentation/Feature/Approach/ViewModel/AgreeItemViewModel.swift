//
//  SecondAgreeItemViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 8/7/25.
//

final class AgreeItemViewModel: ViewModeling {
    
    private var agreeItems = AgreeItem.allCases
    private var checkBoxStates: [AgreeItem : CheckBoxState] = [:]
    private let useCase: AgreeTermsUseCase
    
    enum Input {
        case nextButtonDidTap
    }
    enum Output {
        case agreeTermsResult(Bool)
    }
    
    init(useCase: AgreeTermsUseCase) {
        self.useCase = useCase
        agreeItems.forEach { checkBoxStates[$0] = .unchecked }
    }
    
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
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .nextButtonDidTap:
            do {
                try await useCase.execute(
                    termsOfServiceAgreed: checkBoxStates[.isTermsOfServiceAgreed] == .some(.checked) ? true : false,
                    privacyPolicyAgreed: true,
                    isOver14: true,
                    eventPushAgreed: true
                )
                return .agreeTermsResult(true)
            }
            catch(let error) {
                BeforeGoingLogger.error(error)
                return .agreeTermsResult(false)
            }
        }
    }
}
