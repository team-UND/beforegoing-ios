//
//  CheckBoxFactory.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import UIKit

final class CheckBox: UIButton {
    
    private var currentState: CheckBoxState = .unchecked {
        didSet {
            setStyle()
        }
    }
    
    init(currentState: CheckBoxState = .unchecked) {
        self.currentState = currentState
        super.init(frame: .zero)
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        let component = currentState.component
        self.do {
            $0.setImage(component.image, for: .normal)
            $0.backgroundColor = component.backgroundColor
            $0.layer.borderColor = component.borderColor
            $0.layer.borderWidth = component.borderWidth
            $0.layer.cornerRadius = component.cornerRadius
            $0.isUserInteractionEnabled = true
        }
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.size.equalTo(16.adjustedW)
        }
    }
    
    func updateState(isEnabled: Bool) {
        currentState = isEnabled ? .checked : .unchecked
    }
    
    func updateState(_ state: CheckBoxState) {
        currentState = state
    }
    
    func toggle() -> CheckBoxState {
        return currentState.toggle()
    }
    
    func toggle(isOn: Bool) {
        currentState.toggle(isOn: isOn)
    }
}
