//
//  ButtonType.swift
//  BeforeGoing
//
//  Created by APPLE on 7/25/25.
//

import UIKit

enum ButtonItem {
    case enableLongButton
    case disableLongButton
    case enableShortButton
    case disableShortButton
    case addScenarioButton
    
    var component: ButtonComponent {
        switch self {
        case .enableLongButton:
            return ButtonComponent(
                backgroundColor: .blue400,
                textColor: .gray900,
                width: 350.adjustedW,
                height: 48.adjustedH,
                cornerRadius: 14,
                font: .custom(.bodyLGSemiBold)
            )
        case .disableLongButton:
            return ButtonComponent(
                backgroundColor: .gray200,
                textColor: .gray400,
                width: 350.adjustedW,
                height: 48.adjustedH,
                cornerRadius: 14,
                font: .custom(.bodyLGSemiBold)
            )
        case .enableShortButton:
            return ButtonComponent(
                backgroundColor: .blue400,
                textColor: .gray900,
                width: 168.adjustedW,
                height: 41.adjustedH,
                cornerRadius: 20.5,
                font: .custom(.bodyMDSemiBold)
            )
        case .disableShortButton:
            return ButtonComponent(
                backgroundColor: .white,
                textColor: .gray400,
                borderColor: UIColor.gray300.cgColor,
                borderWidth: 1,
                width: 168.adjustedW,
                height: 41.adjustedH,
                cornerRadius: 20.5,
                font: .custom(.bodyMDSemiBold)
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
                font: .custom(.bodyLGSemiBold)
            )
        }
    }
}
