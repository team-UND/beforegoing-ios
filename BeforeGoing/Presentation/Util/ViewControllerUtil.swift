//
//  ViewControllerUtil.swift
//  BeforeGoing
//
//  Created by APPLE on 9/13/25.
//

import UIKit

enum ViewControllerUtil {
    
    static func replaceRootViewController(to viewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    static func findTopWindow() -> UIWindow {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UIWindow()
        }
        return window
    }
}
