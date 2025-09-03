//
//  SelectAlarmOptionView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

final class SelectAlarmOptionView: BaseView {
    
    private let optionStackView = UIStackView()
    private(set) var noAlarmView = AlarmOptionView(title: "알람 없이 사용")
    private(set) var setTimeAlarmView = AlarmOptionView(title: "설정한 시간에 알림")
    
    override func setStyle() {
        optionStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
    }
    
    override func setUI() {
        addSubview(optionStackView)
        optionStackView.addArrangedSubviews(
            noAlarmView,
            setTimeAlarmView
        )
    }
    
    override func setLayout() {
        optionStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(120.adjustedH)
        }
        noAlarmView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        setTimeAlarmView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
