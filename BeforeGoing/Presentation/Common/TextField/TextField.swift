//
//  TextField.swift
//  BeforeGoing
//
//  Created by APPLE on 8/7/25.
//

import UIKit

final class TextField: UITextField {
    
    var currentType: TextFieldType {
        didSet {
            setStyle()
        }
    }
    
    init(type: TextFieldType) {
        self.currentType = type
        super.init(frame: .zero)
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        let component = currentType.component
        self.do {
            $0.backgroundColor = component.backgroundColor
            $0.font = component.font
            $0.layer.cornerRadius = component.cornerRadius
            $0.layer.borderColor = component.borderColor
            $0.layer.borderWidth = component.borderWidth
            $0.autocapitalizationType = component.autocapitalizationType
        }
    }
    
    private func setLayout() {
        let component = currentType.component
        self.snp.makeConstraints {
            $0.width.equalTo(component.width)
            $0.height.equalTo(component.height)
        }
    }
}
