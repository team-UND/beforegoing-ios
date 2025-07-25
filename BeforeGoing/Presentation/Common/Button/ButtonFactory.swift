//
//  ButtonFactory.swift
//  BeforeGoing
//
//  Created by APPLE on 7/25/25.
//

import UIKit

struct ButtonFactory {
    
    static func createButton(type: ButtonItem, title: String) -> UIButton {
        let button = UIButton()
        
        setButtonStyle(for: button, type: type, title: title)
        setButtonLayout(for: button, type: type)
        
        return button
    }
    
    private static func setButtonStyle(for button: UIButton, type: ButtonItem, title: String) {
        button.do {
            $0.setTitle(title, for: .normal)
            $0.backgroundColor = type.component.backgroundColor
            $0.setTitleColor(type.component.textColor, for: .normal)
            $0.titleLabel?.font = type.component.font
        }
        button.layer.do {
            $0.borderColor = type.component.borderColor
            $0.borderWidth = type.component.borderWidth
            $0.cornerRadius = type.component.cornerRadius
        }
    }
    
    private static func setButtonLayout(for button: UIButton, type: ButtonItem) {
        button.snp.makeConstraints {
            $0.width.equalTo(type.component.width)
            $0.height.equalTo(type.component.height)
        }
    }
}
