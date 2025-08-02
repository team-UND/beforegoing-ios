//
//  BottomNavigationElement.swift
//  BeforeGoing
//
//  Created by APPLE on 7/24/25.
//

enum BottomNavigationItem: CaseIterable {
    case home
    case scenario
    case setting
    
    var component: BottomNavigationComponent {
        switch self {
        case .home:
            return BottomNavigationComponent(
                viewController: HomeViewController(),
                title: BottomNavigationLiteral.home.rawValue,
                image: .home
            )
        case .scenario:
            return BottomNavigationComponent(
                viewController: ScenarioViewController(),
                title: BottomNavigationLiteral.scenario.rawValue,
                image: .list
            )
        case .setting:
            return BottomNavigationComponent(
                viewController: SettingViewController(),
                title: BottomNavigationLiteral.setting.rawValue,
                image: .settings
            )
        }
    }
}
