//
//  ScenarioEmptyViewType.swift
//  BeforeGoing
//
//  Created by APPLE on 10/5/25.
//

import UIKit

enum ScenarioEmptyViewType {
    
    case home, myScenario
    
    var title: String {
        return "등록된 시나리오가 없어요"
    }
    
    var subtitle: String {
        return "버튼을 눌러 시나리오를 만들어 보세요:)"
    }
    
    var isHome: Bool {
        self == .home
    }
}
