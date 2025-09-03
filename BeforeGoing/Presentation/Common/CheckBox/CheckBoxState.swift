//
//  CheckBoxItem.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import UIKit

enum CheckBoxState: Equatable {
    
    case unchecked
    case checked
    
    var component: CheckBoxComponent {
        switch self {
        case .unchecked:
            return CheckBoxComponent(
                backgroundColor: .white,
                image: nil,
                borderColor: UIColor.gray400.cgColor,
                borderWidth: 1
            )
        case .checked:
            return CheckBoxComponent(
                backgroundColor: .blue400,
                image: .check.withTintColor(.white)
            )
        }
    }
    
    mutating func toggle() -> Self {
        self = (self == .checked) ? .unchecked : .checked
        return self
    }
    
    mutating func toggle(isOn: Bool) {
        self = isOn ? .checked : .unchecked
    }
    
    func matchState() -> Bool {
        return self == .checked ? true : false
    }
}
