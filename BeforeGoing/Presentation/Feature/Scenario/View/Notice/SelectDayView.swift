//
//  SelectDayView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

final class SelectDayView: BaseView {
    
    private(set) var dayOfWeeks = ["월", "화", "수", "목", "금", "토", "일"]
    private(set) var dayOfWeeksState: [String : Bool] = [
        "월" : false, "화" : false, "수" : false, "목" : false, "금" : false, "토" : false, "일" : false
    ]
    private(set) var dayOfWeekLabels: [UILabel] = []
    
    private let titleLabel = UILabel()
    private let weekBackgroundView = UIView()
    private let weekStackView = UIStackView()
    private(set) var everydayButton = CheckBox(currentState: .unchecked)
    private let everydayLabel = UILabel()
    
    override func setStyle() {
        titleLabel.do {
            $0.text = "매주"
            $0.textColor = .gray600
            $0.font = .custom(.bodyLGMedium)
        }
        weekBackgroundView.do {
            $0.layer.cornerRadius = 14
            $0.layer.borderColor = UIColor.gray200.cgColor
            $0.layer.borderWidth = 1
        }
        weekStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.distribution = .fillEqually
            $0.alignment = .center
        }
        everydayLabel.do {
            $0.text = "매일"
            $0.textColor = .black
            $0.font = .custom(.bodyMDMedium)
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            weekBackgroundView,
            everydayButton,
            everydayLabel
        )
        weekBackgroundView.addSubview(weekStackView)
        dayOfWeeks.forEach {
            let dayOfWeekLabel = createDayOfWeekLabel(dayOfWeek: $0)
            dayOfWeekLabels.append(dayOfWeekLabel)
        }
        dayOfWeekLabels.forEach { weekStackView.addArrangedSubview($0) }
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        weekBackgroundView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        weekStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(1.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(16.adjustedW)
        }
        everydayLabel.snp.makeConstraints {
            $0.top.equalTo(weekBackgroundView.snp.bottom).offset(8.adjustedH)
            $0.trailing.bottom.equalToSuperview()
        }
        everydayButton.snp.makeConstraints {
            $0.size.equalTo(16.adjustedW)
            $0.trailing.equalTo(everydayLabel.snp.leading).offset(-4.adjustedW)
            $0.top.equalTo(weekBackgroundView.snp.bottom).offset(8.adjustedH)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func createDayOfWeekLabel(dayOfWeek: String) -> UILabel {
        let dayOfWeekLabel = UILabel()
        setDayOfWeekLabelStyle(dayOfWeekLabel, text: dayOfWeek)
        setDayOfWeekLabelLayout(dayOfWeekLabel)
        return dayOfWeekLabel
    }
    
    private func setDayOfWeekLabelStyle(_ dayOfWeekLabel: UILabel, text: String) {
        dayOfWeekLabel.do {
            $0.text = text
            $0.textAlignment = .center
            $0.textColor = .gray400
            $0.font = .custom(.bodyLGMedium)
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
        }
    }
    
    private func setDayOfWeekLabelLayout(_ dayOfWeekLabel: UILabel) {
        dayOfWeekLabel.snp.makeConstraints {
            $0.width.equalTo(42.adjustedW)
            $0.height.equalTo(38.adjustedH)
        }
    }
}

extension SelectDayView {
    
    var isCheckedDay: Bool {
        let isChecked = dayOfWeeksState.contains(where: { $1 == true })
        return isChecked
    }
    
    func updateDayOfWeekState(dayText: String) {
        guard let index = dayOfWeeks.firstIndex(of: dayText) else { return }
        
        dayOfWeeksState[dayText]?.toggle()
        if let isSelected = dayOfWeeksState[dayText] {
            updateUI(index: index, condition: isSelected)
        }
    }
    
    func updateAllDay(condition: Bool) {
        for (index, day) in dayOfWeeks.enumerated() {
            dayOfWeeksState[day] = condition
            updateUI(index: index, condition: condition)
        }
    }
    
    private func updateUI(index: Int, condition: Bool) {
        dayOfWeekLabels[index].do {
            $0.textColor = condition ? .blue700 : .gray400
            $0.backgroundColor = condition ? .blue100 : .clear
        }
    }
    
    func checkAllSelected() {
        let isAllSelected = dayOfWeeks.allSatisfy { dayOfWeeksState[$0] == true }
        everydayButton.toggle(isOn: isAllSelected)
    }
}
