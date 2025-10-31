//
//  SettingNoticeView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class SettingNoticeView: BaseView {
    
    private let titleLabel = UILabel()
    private(set) var basicPushNoticeView = SettingPushNoticeView(title: "푸시 알림")
    private let divider = UILabel()
    
    override func setStyle() {
        titleLabel.do {
            $0.text = "알림 설정"
            $0.textColor = .gray400
            $0.font = .custom(.bodyLGSemiBold)
        }
        divider.do {
            $0.backgroundColor = .gray50
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            basicPushNoticeView,
            divider
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.adjustedH)
            $0.leading.equalToSuperview().inset(20.adjustedW)
        }
        basicPushNoticeView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(46.adjustedH)
        }
        divider.snp.makeConstraints {
            $0.top.equalTo(basicPushNoticeView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(6.adjustedH)
            $0.bottom.equalToSuperview()
        }
    }
}
