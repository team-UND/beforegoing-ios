//
//  CustomButton.swift
//  BeforeGoing
//
//  Created by APPLE on 8/5/25.
//

import UIKit

final class CustomButton: UIButton {
    
    init(state: ButtonState, title: String) {
        super.init(frame: .zero)
        setStyle(state: state, title: title)
        setLayout(state: state)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle(state: ButtonState, title: String) {
        self.setTitle(title, for: .normal)
        setStyle(state: state)
    }
    
    private func setStyle(state: ButtonState) {
        let compoonent = state.component
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
    
    func updateUI(state: ButtonState) {
        setStyle(state: state)
        setLayout(state: state)
    }
}
