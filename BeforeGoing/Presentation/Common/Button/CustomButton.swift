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
        let compoonent = currentState.component
        self.do {
            $0.backgroundColor = compoonent.backgroundColor
            $0.setTitleColor(compoonent.textColor, for: .normal)
            $0.titleLabel?.font = compoonent.font
            $0.layer.borderColor = compoonent.borderColor
            $0.layer.borderWidth = compoonent.borderWidth
            $0.layer.cornerRadius = compoonent.cornerRadius
        }
    }
    
    private func setLayout(state: ButtonState) {
        let compoonent = state.component
        self.snp.makeConstraints {
            $0.width.equalTo(compoonent.width)
            $0.height.equalTo(compoonent.height)
        }
    }
}
