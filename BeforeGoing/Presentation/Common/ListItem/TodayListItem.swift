//
//  TodayListItem.swift
//  BeforeGoing
//
//  Created by APPLE on 8/19/25.
//

import UIKit

final class TodayListItem: TodayListItemComponentView {
    
    private(set) var checkBoxView = UIView()
    private(set) var checkBox = CheckBox(currentState: .unchecked)
    private let contentLabel = UILabel()
    
    override func setStyle() {
        super.setStyle()
        
        self.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 1.4
            $0.layer.borderColor = UIColor.blue50.cgColor
        }
        checkBoxView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
        contentLabel.do {
            $0.textColor = .gray900
            $0.font = .custom(.bodyLGMedium)
        }
    }
    
    override func setUI() {
        super.setUI()
        
        addSubviews(
            checkBoxView,
            contentLabel
        )
        checkBoxView.addSubview(checkBox)
    }
    
    override func setLayout() {
        super.setLayout()

        checkBoxView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
            $0.width.equalTo(40.adjustedW)
        }
        checkBox.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.adjustedW)
            $0.centerY.equalToSuperview()
        }
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(todayBackgroundView.snp.trailing).offset(8.adjustedW)
            $0.centerY.equalToSuperview()
        }
        todayBackgroundView.snp.makeConstraints {
            $0.leading.equalTo(checkBox.snp.trailing).offset(8.adjustedW)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(56.adjustedW)
            $0.height.equalTo(25.adjustedH)
        }
    }
}

extension TodayListItem: ListItemProtocol {
    
    func updateText(_ text: String) {
        contentLabel.text = text
    }
}
