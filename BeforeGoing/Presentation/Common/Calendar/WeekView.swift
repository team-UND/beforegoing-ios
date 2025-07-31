//
//  WeekView.swift
//  BeforeGoing
//
//  Created by APPLE on 7/30/25.
//

import UIKit

final class WeekView: BaseView {
    
    private let daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
    
    private let weekStackView = UIStackView()
    
    override func setStyle() {
        weekStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .center
        }
        daysOfWeek.forEach {
            let dayOfWeek = $0
            let daysOfWeekLabel = UILabel()
            daysOfWeekLabel.do {
                $0.text = dayOfWeek
                $0.textColor = .gray600
                $0.textAlignment = .center
                $0.font = .custom(.bodyLGMedium)
            }
            weekStackView.addArrangedSubview(daysOfWeekLabel)
        }
    }
    
    override func setUI() {
        addSubview(weekStackView)
    }
    
    override func setLayout() {
        weekStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
