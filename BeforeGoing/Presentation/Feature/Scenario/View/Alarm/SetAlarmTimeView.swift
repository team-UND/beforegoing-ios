//
//  SetAlarmTimeView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

final class SetAlarmTimeView: BaseView {
    
    private let divider = UILabel()
    private let titleLabel = UILabel()
    private(set) var selectDayView = SelectDayView()
    private(set) var timePickerView = TimePickerView()
    
    override func setStyle() {
        self.do {
            $0.isHidden = true
        }
        divider.do {
            $0.backgroundColor = .gray50
        }
        titleLabel.do {
            $0.text = "알림 시간 설정"
            $0.textColor = .gray900
            $0.font = .custom(.headingH5)
        }
    }
    
    override func setUI() {
        addSubviews(
            divider,
            titleLabel,
            selectDayView,
            timePickerView
        )
    }
    
    override func setLayout() {
        divider.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(6.adjustedH)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(20.adjustedH)
            $0.leading.equalToSuperview().inset(20.adjustedW)
        }
        selectDayView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(102.adjustedH)
        }
        timePickerView.snp.makeConstraints {
            $0.top.equalTo(selectDayView.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(179.adjustedH)
        }
    }
}

extension SetAlarmTimeView {
    
    func updateHiddenState(isSelectedUseTime: Bool) {
        self.isHidden = isSelectedUseTime ? false : true
    }
}
