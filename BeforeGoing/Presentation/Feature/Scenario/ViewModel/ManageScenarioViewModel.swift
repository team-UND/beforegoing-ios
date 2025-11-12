//
//  ManageScenarioViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 11/12/25.
//

protocol ManageScenarioOutput {}

final class ManageScenarioViewModel: ViewModeling {
    
    private var templates = ScenarioType.allCases
    
    enum Input {
        case selectButtonDidTap
    }

    typealias Output = ManageScenarioOutput
    
    struct TemplatesOutput: ManageScenarioOutput {
        let templates: [ScenarioType]
    }
    
    func action(input: Input) -> Output {
        switch input {
        case .selectButtonDidTap:
            return TemplatesOutput(templates: templates)
        }
    }
}

extension ManageScenarioViewModel {
    
    var templateCount: Int {
        templates.count
    }
    
    func findScenarioType(index: Int) -> ScenarioType? {
        templates[index]
    }
    
    func addScenarioType(_ newElement: ScenarioType, at index: Int) {
        templates.insert(newElement, at: index)
    }
    
    func removeScenarioType(at index: Int) -> ScenarioType? {
        guard index >= 0 && index < templates.count else {
            return nil
        }
        let removed = templates.remove(at: index)
        return removed
    }
}
