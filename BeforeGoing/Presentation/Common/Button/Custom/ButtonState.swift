//
//  ButtonType.swift
//  BeforeGoing
//
//  Created by APPLE on 7/25/25.
//

import UIKit

enum ButtonState {
    case enableLongButton
    case disableLongButton
    case addScenarioButton
    
    var component: ButtonComponent {
        switch self {
        case .enableLongButton:
            return ButtonComponent(
                backgroundColor: .blue400,
                textColor: .gray900,
                borderColor: nil,
                borderWidth: 0,
                width: 350.adjustedW,
                height: 48.adjustedH,
                cornerRadius: 14,
                font: .custom(.bodyLGSemiBold),
                isEnabled: true
            )
        case .disableLongButton:
            return ButtonComponent(
                backgroundColor: .gray200,
                textColor: .gray400,
                borderColor: nil,
                borderWidth: 0,
                width: 350.adjustedW,
                height: 48.adjustedH,
                cornerRadius: 14,
                font: .custom(.bodyLGSemiBold),
                isEnabled: false
            )
        case .addScenarioButton:
            return ButtonComponent(
                backgroundColor: .white,
                textColor: .blue500,
                borderColor: UIColor.blue400.cgColor,
                borderWidth: 1.5,
                width: 350.adjustedW,
                height: 48.adjustedH,
                cornerRadius: 14,
                font: .custom(.bodyLGSemiBold),
                isEnabled: true
            )
        }
    }
}
