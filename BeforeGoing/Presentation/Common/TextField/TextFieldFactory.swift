//
//  TextFieldFactory.swift
//  BeforeGoing
//
//  Created by APPLE on 7/25/25.
//

import UIKit

struct TextFieldFactory {
    
    static func createTextField(type: TextFieldItem) -> UITextField {
        let textField = UITextField()
        let addButton = createAddButton(type: type)
        
        textField.do {
            $0.backgroundColor = type.component.backgroundColor
            $0.font = type.component.font
        }
        textField.layer.do {
            $0.cornerRadius = type.component.cornerRadius
            $0.borderColor = type.component.borderColor
            $0.borderWidth = type.component.borderWidth
        }
        
        textField.snp.makeConstraints {
            $0.width.equalTo(type.component.width)
            $0.height.equalTo(type.component.height)
        }
        
        guard let addButton = addButton else { return textField }
        
        textField.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.trailing.equalTo(textField.snp.trailing).offset(-20.adjustedW)
            $0.centerY.equalToSuperview()
        }
        return textField
    }
    
    private static func createAddButton(type: TextFieldItem) -> UIButton? {
        if type == .nicknameField || type == .settingField {
            return nil
        }
        
        let addButton = UIButton()
        addButton.do {
            $0.setImage(.plusCircle.withTintColor(.gray400), for: .normal)
        }
        return addButton
    }
}
