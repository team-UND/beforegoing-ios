//
//  SplashViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import UIKit

final class SplashViewController: BaseViewController {
    
    private let rootView = SplashView()
    
    override func loadView() {
        view = rootView
    }
}
