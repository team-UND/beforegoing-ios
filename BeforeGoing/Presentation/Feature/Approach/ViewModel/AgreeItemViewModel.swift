//
//  AgreeItemViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 8/5/25.
//

final class AgreeItemViewModel {
    
    struct Output {
        var currentAgreeItem: Observable<[AgreeItem: CheckBoxState]> = {
            var checkBoxStates: [AgreeItem: CheckBoxState] = [:]
            AgreeItem.allCases.forEach { checkBoxStates[$0] = .unchecked }
            return Observable<[AgreeItem: CheckBoxState]>(checkBoxStates)
        }()
    }
    
    private(set) var output = Output()
}

extension AgreeItemViewModel {
    
    func bindAll(checkBoxState: CheckBoxState) -> Bool {
        let updatedAgreeItem = output.currentAgreeItem.data.mapValues { _ in checkBoxState }
        output.currentAgreeItem.data = updatedAgreeItem
        return isAllChecked()
    }
    
    func bindItem(_ item: AgreeItem, checkBoxState: CheckBoxState) -> Bool {
        output.currentAgreeItem.data[item] = checkBoxState
        return isAllNecessaryChecked()
    }
    
    func isAllChecked() -> Bool {
        return output.currentAgreeItem.data
            .allSatisfy { $0.value == .checked }
    }
    
    private func isAllNecessaryChecked() -> Bool {
        return output.currentAgreeItem.data
            .filter { $0.key.component.isNecessary }
            .allSatisfy { $0.value == .checked }
    }
}
