//
//  SettingNoticeView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class SettingNoticeView: BaseView {
    
    private let titleLabel = UILabel()
    private(set) var locationAuthorizationView = SettingPushNoticeView(
        title: "위치 접근 허용 동의",
        subtitle: "현재 위치의 기상정보와 추천 준비물을 확인할 수 있어요."
    )
    private(set) var basicPushNoticeView = SettingPushNoticeView(
        title: "푸시 알림 / 알람 설정",
        subtitle: "설정한 알림을 받아볼 수 있어요."
    )
    private(set) var eventPushNoticeView = SettingPushNoticeView(
        title: "이벤트 / 마케팅 앱 푸시 수신동의",
        subtitle: "이벤트, 혜택 등 유용한 정보를 받아볼 수 있어요."
    )
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
            locationAuthorizationView,
            basicPushNoticeView,
            eventPushNoticeView,
            divider
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12.adjustedH)
            $0.leading.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(29.adjustedH)
        }
        locationAuthorizationView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(46.adjustedH)
        }
        basicPushNoticeView.snp.makeConstraints {
            $0.top.equalTo(locationAuthorizationView.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(46.adjustedH)
        }
        eventPushNoticeView.snp.makeConstraints {
            $0.top.equalTo(basicPushNoticeView.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(46.adjustedH)
        }
        divider.snp.makeConstraints {
            $0.top.equalTo(eventPushNoticeView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(6.adjustedH)
            $0.bottom.equalToSuperview()
        }
    }
}
