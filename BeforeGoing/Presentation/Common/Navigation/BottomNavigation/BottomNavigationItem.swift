//
//  BottomNavigationElement.swift
//  BeforeGoing
//
//  Created by APPLE on 7/24/25.
//

enum BottomNavigationItem: Int, CaseIterable {
    case home = 0
    case scenario
    case setting
    
    var component: BottomNavigationComponent {
        switch self {
        case .home:
            return BottomNavigationComponent(
                viewController: ViewControllerFactory.shared.makeHomeViewController(),
                title: BottomNavigationLiteral.home.rawValue,
                image: .home
            )
        case .scenario:
            return BottomNavigationComponent(
                viewController: ViewControllerFactory.shared.makeMyScenarioViewController(),
                title: BottomNavigationLiteral.scenario.rawValue,
                image: .list
            )
        case .setting:
            return BottomNavigationComponent(
                viewController: ViewControllerFactory.shared.makeSettingViewController(),
                title: BottomNavigationLiteral.setting.rawValue,
                image: .settings
            )
        }
    }
}
