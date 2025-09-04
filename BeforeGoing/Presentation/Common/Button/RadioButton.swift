//
//  RadioButton.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

final class RadioButton: UIButton {
    
    var currentState: RadioButtonState {
        didSet { self.setImage(currentState.image, for: .normal) }
    }
    
    init(state: RadioButtonState = .disable) {
        self.currentState = state
        super.init(frame: .zero)
        setStyle()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.setImage(currentState.image, for: .normal)
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.size.equalTo(16.adjustedW)
        }
    }
}

extension RadioButton {
    
    func updateState() {
        currentState.toggle()
    }
    
    func matchState() -> Bool {
        return currentState.matchState()
    }
    
    func changeState(_ state: Bool) {
        currentState.setCurrentState(state)
    }
}
