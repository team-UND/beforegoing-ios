//
//  BeforeGoingNavigationBar.swift
//  BeforeGoing
//
//  Created by APPLE on 7/22/25.
//

import UIKit

import SnapKit
import Then

enum NavigationBarType: Equatable {
    
    case clear, none
}

struct TopNavigationBar {
    
    static func makeNavigationBar(
        navigationController: UINavigationController?,
        type: NavigationBarType
    ) {
        if type == .none {
            navigationController?.navigationBar.isHidden = true
            return
        }
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.do {
            $0.configureWithTransparentBackground()
            $0.shadowColor = .clear
        }
        
        navigationController?.navigationBar.do {
            $0.standardAppearance = barAppearance
            $0.scrollEdgeAppearance = barAppearance
        }
    }
}
