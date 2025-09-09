//
//  CustomButton.swift
//  BeforeGoing
//
//  Created by APPLE on 8/5/25.
//

import UIKit

final class CustomButton: UIButton {
    
    var currentState: ButtonState {
        didSet {
            setStyle()
        }
    }
    
    init(state: ButtonState, title: String) {
        self.currentState = state
        super.init(frame: .zero)
        setStyle(title: title)
        setLayout(state: state)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle(title: String) {
        self.setTitle(title, for: .normal)
        setStyle()
    }
    
    private func setStyle() {
        let component = currentState.component
        self.do {
            $0.backgroundColor = component.backgroundColor
            $0.setTitleColor(component.textColor, for: .normal)
            $0.titleLabel?.font = component.font
            $0.layer.borderColor = component.borderColor
            $0.layer.borderWidth = component.borderWidth
            $0.layer.cornerRadius = component.cornerRadius
            $0.isEnabled = component.isEnabled
        }
    }
    
    private func setLayout(state: ButtonState) {
        let component = state.component
        self.snp.makeConstraints {
            $0.width.equalTo(component.width)
            $0.height.equalTo(component.height)
        }
    }
}

extension CustomButton {
    
    func reverseState(isEnabled: Bool) {
        if isEnabled {
            if currentState == .disableLongButton {
                currentState = .enableLongButton
            } else if currentState == .disableShortButton {
                currentState = .enableShortButton
            }
            return
        }
        if currentState == .enableLongButton {
            currentState = .disableLongButton
        } else if currentState == .enableShortButton {
            currentState = .enableShortButton
        }
    }
    
    func updateTitle(_ title: String) {
        self.setTitle(title, for: .normal)
    }
}
