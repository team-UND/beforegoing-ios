//
//  SelectTimeView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

final class TimePickerView: BaseView {
    
    private let titleLabel = UILabel()
    private let datePicker = UIDatePicker()
    
    override func setStyle() {
        titleLabel.do {
            $0.text = "시간"
            $0.textColor = .gray600
            $0.font = .custom(.bodyLGMedium)
        }
        datePicker.do {
            $0.preferredDatePickerStyle = .wheels
            $0.datePickerMode = .time
            $0.minuteInterval = 1
            $0.locale = Locale(identifier: "ko_KR")
            //$0.addTarget(self, action: #selector(timeDidChange), for: .valueChanged)
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            datePicker
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        datePicker.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(149.adjustedH)
        }
    }
}

extension TimePickerView {
    
    @objc
    private func timeDidChange(sender: UIDatePicker) {
        let dateString = convertToString(date: sender.date)
    }
    
    private func convertToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a h:mm"
        return dateFormatter.string(from: date)
    }
}
