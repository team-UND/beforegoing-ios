//
//  NicknameView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/6/25.
//

import UIKit

final class NicknameView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let topNavigationView = TopNavigationView(title: "환영합니다")
    private let nameLabel = UILabel()
    private let necessaryLabel = UILabel()
    let nicknameTextField = TextField(type: .nicknameField)
    private let startButton = CustomButton(state: .disableLongButton, title: "시작하기")
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgTop
        }
        nameLabel.do {
            $0.text = "이름"
            $0.textColor = .gray600
            $0.font = .custom(.headingH5)
        }
        necessaryLabel.do {
            $0.text = "*"
            $0.textColor = .warning600
            $0.font = .custom(.bodyLGMedium)
        }
        nicknameTextField.do {
            $0.placeholder = "ex) 워리 (최대 8자)"
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nicknameTextField.frame.height))
            $0.leftViewMode = .always
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            topNavigationView,
            nameLabel,
            necessaryLabel,
            nicknameTextField,
            startButton
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        topNavigationView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.adjustedH)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(topNavigationView.snp.bottom).offset(40.adjustedH)
            $0.leading.equalToSuperview().inset(20.adjustedW)
        }
        necessaryLabel.snp.makeConstraints {
            $0.top.equalTo(topNavigationView.snp.bottom).offset(40.adjustedH)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(4.adjustedW)
        }
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(8.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
        }
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(34.adjustedH)
        }
    }
}

extension NicknameView {
    
    func enableStartButton() {
        startButton.updateUI(state: .enableLongButton)
    }
    
    func disableStartButton() {
        startButton.updateUI(state: .disableLongButton)
    }
}
