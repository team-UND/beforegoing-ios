//
//  CalendarHeaderView.swift
//  BeforeGoing
//
//  Created by APPLE on 7/30/25.
//

import UIKit

final class CalendarHeaderView: BaseView {
    
    private let dateLabel = UILabel()
    let previousButton = UIButton()
    let nextButton = UIButton()
    
    override func setStyle() {
        dateLabel.do {
            $0.textColor = .gray900
            $0.font = .custom(.bodyLGSemiBold)
        }
        previousButton.setImage(.chevronLeft, for: .normal)
        nextButton.setImage(.chevronRight, for: .normal)
    }
    
    override func setUI() {
        addSubviews(
            previousButton,
            dateLabel,
            nextButton
        )
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(310.adjustedW)
            $0.height.equalTo(19.adjustedH)
        }
        dateLabel.snp.makeConstraints {
            $0.center.equalTo(self.snp.center)
        }
        previousButton.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading).offset(12.adjustedW)
            $0.size.equalTo(19.adjustedW)
        }
        nextButton.snp.makeConstraints {
            $0.trailing.equalTo(self.snp.trailing).offset(-12.adjustedW)
            $0.size.equalTo(19.adjustedW)
        }
    }
}

extension CalendarHeaderView {
    
    func bind(year: Int, month: Int) {
        dateLabel.text = "\(year)년 \(month)월"
    }
}
