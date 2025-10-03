//
//  SettingScenarioEnterType.swift
//  BeforeGoing
//
//  Created by APPLE on 10/1/25.
//

enum SettingScenarioEnterType {
    case addScenario
    case updateScenario
    
    var isAddScenarioType: Bool {
        self == .addScenario
    }
}
