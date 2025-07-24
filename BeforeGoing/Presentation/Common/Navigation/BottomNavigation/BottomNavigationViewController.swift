//
//  BottomNavigationBar.swift
//  BeforeGoing
//
//  Created by APPLE on 7/24/25.
//

import UIKit

import Then

final class BottomNavigationViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        setAppearance()
    }
    
    private func setViewControllers() {
        self.viewControllers = BottomNavigationItem.allCases.map {
             createViewController(
                for: $0.component.viewController,
                title: $0.component.title,
                image: $0.component.image
            )
        }
    }
    
    private func setAppearance() {
        let barAppearance = createTabBarAppearance()
        let itemAppearance = createItemAppearance()
        registerAppearance(for: barAppearance, to: itemAppearance)
    }
    
    private func createViewController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage
    ) -> UIViewController {
        let viewController = UINavigationController(rootViewController: rootViewController)
        rootViewController.tabBarItem.do{
            $0.title = title
            $0.image = image.withRenderingMode(.alwaysTemplate)
        }
        return viewController
    }
    
    private func createTabBarAppearance() -> UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.do {
            $0.configureWithTransparentBackground()
            $0.backgroundColor = .white
        }
        return appearance
    }
    
    private func createItemAppearance() -> UITabBarItemAppearance {
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.do {
            $0.selected.iconColor = .blue500
            $0.selected.titleTextAttributes = [
                .foregroundColor: UIColor.blue500,
                .font: UIFont.custom(.bodyMDMedium)
            ]
            
            $0.normal.iconColor = .gray400
            $0.normal.titleTextAttributes = [
                .foregroundColor: UIColor.gray400,
                .font: UIFont.custom(.bodyMDMedium)
            ]
        }
        return itemAppearance
    }
    
    private func registerAppearance(
        for barAppearance: UITabBarAppearance,
        to itemAppearance: UITabBarItemAppearance
    ) {
        barAppearance.stackedLayoutAppearance = itemAppearance
        tabBar.standardAppearance = barAppearance
        tabBar.scrollEdgeAppearance = barAppearance
    }
}
