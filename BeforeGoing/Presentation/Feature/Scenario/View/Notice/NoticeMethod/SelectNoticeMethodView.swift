//
//  AlarmMethodView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class SelectNoticeMethodView: BaseView {
    
    private let methodStackView = UIStackView()
    private(set) var pushNoticeView = NoticeMethodView(type: .pushNotice)
    private(set) var alarmView = NoticeMethodView(type: .alarm)
    
    override func setStyle() {
        methodStackView.do {
            $0.axis = .horizontal
            $0.spacing = 16
            $0.distribution = .fillEqually
        }
    }
    
    override func setUI() {
        addSubview(methodStackView)
        methodStackView.addArrangedSubviews(
            pushNoticeView,
            alarmView
        )
    }
    
    override func setLayout() {
        methodStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(256.adjustedW)
            $0.height.equalTo(313.adjustedH)
        }
    }
}

extension SelectNoticeMethodView {
    
    func toggleMethod(selectedView: NoticeMethodView) {
        let isPushNoticeSelected = selectedView == pushNoticeView
        
        pushNoticeView.do {
            $0.radioButton.changeState(isPushNoticeSelected)
            $0.updateImage(isSelected: isPushNoticeSelected)
        }
        alarmView.do {
            $0.radioButton.changeState(!isPushNoticeSelected)
            $0.updateImage(isSelected: !isPushNoticeSelected)
        }
    }
}
