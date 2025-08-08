//
//  SecondAgreeItemViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 8/7/25.
//

final class AgreeItemViewModel {
    
    private var agreeItems = AgreeItem.allCases
    private var checkBoxStates: [AgreeItem : CheckBoxState] = [:]
    
    init() {
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
}
