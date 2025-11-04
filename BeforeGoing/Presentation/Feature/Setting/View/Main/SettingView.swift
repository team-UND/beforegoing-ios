//
//  SettingView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class SettingView: BaseView {
    
    private let titleLabel = UILabel()
    private(set) var accountView = AccountView()
    private(set) var supportView = SupportView()
    private(set) var settingNoticeView = SettingNoticeView()
    private(set) var policyView = PolicyView()
    
    override func setStyle() {
        titleLabel.do {
            $0.text = "설정"
            $0.textColor = .gray900
            $0.font = .custom(.headingH3)
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            accountView,
            supportView,
            settingNoticeView,
            policyView
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(48.adjustedH)
        }
        accountView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(77.adjustedH)
        }
        supportView.snp.makeConstraints {
            $0.top.equalTo(accountView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(77.adjustedH)
        }
        settingNoticeView.snp.makeConstraints {
            $0.top.equalTo(supportView.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(191.adjustedH)
        }
        policyView.snp.makeConstraints {
            $0.top.equalTo(settingNoticeView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(180.adjustedH)
        }
    }
}

extension SettingView {
    
    var isSwitchedOn: Bool {
        settingNoticeView.basicPushNoticeView.switchButton.isOn
    }
    
    func updateSwitch(isAgreed: Bool) {
        settingNoticeView.basicPushNoticeView.switchButton.isSelected = isAgreed
    }
}
