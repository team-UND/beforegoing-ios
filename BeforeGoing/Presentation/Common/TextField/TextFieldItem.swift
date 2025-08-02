//
//  TextFieldItem.swift
//  BeforeGoing
//
//  Created by APPLE on 7/25/25.
//

import UIKit

enum TextFieldItem: Equatable {
    case nicknameField
    case enableAddField
    case disableAddField
    case settingField
    
    var component: TextFieldComponent {
        switch self {
        case .nicknameField:
            return TextFieldComponent(
                backgroundColor: .gray50,
                width: 350.adjustedW,
                height: 44.adjustedH
            )
        case .enableAddField:
            return TextFieldComponent(
                backgroundColor: .gray50,
                width: 350.adjustedW,
                height: 44.adjustedH,
                borderColor: UIColor.blue400.cgColor,
                borderWidth: 1
            )
        case .disableAddField:
            return TextFieldComponent(
                backgroundColor: .gray200,
                width: 350.adjustedW,
                height: 44.adjustedH,
                borderColor: UIColor.gray400.cgColor,
                borderWidth: 1
            )
        case .settingField:
            return TextFieldComponent(
                backgroundColor: .gray50,
                width: 350.adjustedW,
                height: 54.adjustedH,
                borderColor: UIColor.blue50.cgColor,
                borderWidth: 1
            )
        }
    }
}
