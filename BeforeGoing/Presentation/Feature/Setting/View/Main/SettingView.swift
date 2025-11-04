//
//  SettingView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class SettingView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
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
            scrollView
        )
        scrollView.addSubview(contentView)
        contentView.addSubviews(
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
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide.snp.horizontalEdges)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        accountView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        supportView.snp.makeConstraints {
            $0.top.equalTo(accountView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        settingNoticeView.snp.makeConstraints {
            $0.top.equalTo(supportView.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        policyView.snp.makeConstraints {
            $0.top.equalTo(settingNoticeView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20.adjustedH)
        }
    }
}

extension SettingView {
    
    var isSwitchedOn: Bool {
        settingNoticeView.basicPushNoticeView.switchButton.isOn
    }
    
    func configure(version: String) {
        policyView.versionLabel.text = version
    }
    
    func updateSwitch(isAgreed: Bool) {
        settingNoticeView.basicPushNoticeView.switchButton.isSelected = isAgreed
    }
}
