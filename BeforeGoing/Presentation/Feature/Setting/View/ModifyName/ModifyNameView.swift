//
//  ModifyNameView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/5/25.
//

import UIKit

final class ModifyNameView: BaseView {
    
    private let maxLength = 8
    
    private let navigationView = TopNavigationView(title: "이름을 입력해주세요")
    private let nameLabel = UILabel()
    private(set) var letterCountLabel = UILabel()
    private(set) var nameTextField = TextField(type: .nicknameField)
    private let deleteButton = UIButton()
    private(set) var confirmButton = CustomButton(state: .enableLongButton, title: "확인")
    
    override func setStyle() {
        nameLabel.do {
            $0.text = "이름"
            $0.textColor = .gray600
            $0.font = .custom(.bodyLGMedium)
        }
        letterCountLabel.do {
            $0.textColor = .gray400
            $0.font = .custom(.bodyMDMedium)
        }
        nameTextField.do {
            $0.placeholder = "ex) 워리"
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nameTextField.frame.height))
            $0.leftViewMode = .always
        }
        deleteButton.do {
            $0.setImage(.union, for: .normal)
            $0.isHidden = true
        }
    }
    
    override func setUI() {
        addSubviews(
            navigationView,
            nameLabel,
            letterCountLabel,
            nameTextField,
            confirmButton
        )
    }
    
    override func setLayout() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48.adjustedH)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(40.adjustedH)
            $0.leading.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(22.adjustedH)
        }
        letterCountLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(40.adjustedH)
            $0.trailing.equalToSuperview().inset(20.adjustedW)
            $0.centerY.equalTo(nameLabel.snp.centerY)
        }
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
        }
        confirmButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(34.adjustedH)
        }
    }
}

extension ModifyNameView {
    
    func configureName(_ name: String) {
        nameTextField.text = name
        letterCountLabel.text = "\(name.count)/\(maxLength)"
    }
    
    func updateDeleteButtonState(condition: Bool) {
        deleteButton.isHidden = condition ? true : false
    }
    
    func updateNameCount(_ count: Int) {
        letterCountLabel.text = "\(count)/\(maxLength)"
    }
    
    func updateConfirmButtonState(condition: Bool) {
        confirmButton.currentState = condition ? .enableLongButton : .disableLongButton
    }
}
