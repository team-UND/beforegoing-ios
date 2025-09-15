//
//  ViewControllerUtil.swift
//  BeforeGoing
//
//  Created by APPLE on 9/13/25.
//

import UIKit

final class ViewControllerUtil {
    
    static let shared = ViewControllerUtil()
    private init() {}
    
    func replaceRootViewController(to viewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
