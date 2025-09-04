//
//  RadioButtonState.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

enum RadioButtonState {
    case enable, disable
    
    var image: UIImage {
        switch self {
        case .enable:
            return .enableRadio
        case .disable:
            return .disableRadio
        }
    }
    
    mutating func toggle() {
        if self == .enable {
            self = .disable
            return
        }
        self = .enable
    }
    
    func matchState() -> Bool {
        return self == .enable ? true : false
    }
    
    mutating func setCurrentState(_ state: Bool) {
        self = state ? .enable : .disable
    }
}
