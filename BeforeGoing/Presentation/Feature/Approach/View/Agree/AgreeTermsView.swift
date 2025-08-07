//
//  AgreeTermsView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import UIKit

final class AgreeTermsView: BaseView {
    
    let topNavigationView = TopNavigationView(title: "약관동의")
    private let backgroundImageView = UIImageView()
    let checkBox = CheckBox()
    private let agreeToAllLabel = UILabel()
    private let dividerLabel = UILabel()
    let tableView = UITableView()
    private let introduceLabel = UILabel()
    let agreeButton = CustomButton(state: .disableLongButton, title: "동의하기")
            
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgTop
        }
        agreeToAllLabel.do {
            $0.text = "약관 전체동의"
            $0.textColor = .gray900
            $0.font = .custom(.headingH5)
        }
        dividerLabel.do {
            $0.backgroundColor = .gray200
        }
        tableView.do {
            $0.separatorStyle = .none
        }
        introduceLabel.do {
            $0.backgroundColor = .warning50
            $0.text = "*필수 약관에 모두 동의해주세요."
            $0.textColor = .warning600
            $0.font = .custom(.bodySMSemiBold)
            $0.textAlignment = .center
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 14
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            topNavigationView,
            checkBox,
            agreeToAllLabel,
            dividerLabel,
            tableView,
            agreeButton,
            introduceLabel
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
        checkBox.snp.makeConstraints {
            $0.top.equalTo(topNavigationView.snp.bottom).offset(40.adjustedH)
            $0.leading.equalToSuperview().inset(20.adjustedW)
        }
        agreeToAllLabel.snp.makeConstraints {
            $0.top.equalTo(topNavigationView.snp.bottom)
            $0.leading.equalTo(checkBox.snp.trailing).offset(8.adjustedW)
            $0.centerY.equalTo(checkBox.snp.centerY)
        }
        dividerLabel.snp.makeConstraints {
            $0.top.equalTo(checkBox.snp.bottom).offset(20.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(1.adjustedH)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(dividerLabel.snp.bottom).offset(4.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(200.adjustedH)
        }
        agreeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(34.adjustedH)
        }
        introduceLabel.snp.makeConstraints {
            $0.bottom.equalTo(agreeButton.snp.top).offset(-10.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180.adjustedW)
            $0.height.equalTo(30.adjustedH)
        }
    }
}

extension AgreeTermsView {
    
    func enableAgreement() {
        introduceLabel.isHidden = true
        agreeButton.updateUI(state: .enableLongButton)
    }
    
    func disableAgreement() {
        introduceLabel.isHidden = false
        agreeButton.updateUI(state: .disableLongButton)
    }
}
