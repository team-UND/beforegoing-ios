//
//  CompletedListItem.swift
//  BeforeGoing
//
//  Created by APPLE on 8/19/25.
//

import UIKit

final class CompletedListItem: TodayListItemComponentView, ListItemProtocol {
    
    private(set) var checkBox = CheckBox(currentState: .unchecked)
    private let contentLabel = UILabel()
    
    private let beforeState: ListItemState
    
    init(beforeState: ListItemState) {
        self.beforeState = beforeState
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.do {
            $0.checkBox.setImage(.completed, for: .normal)
            $0.checkBox.backgroundColor = .clear
            $0.checkBox.layer.borderWidth = 0
            $0.checkBox.isEnabled = false
            $0.layer.cornerRadius = 14
            $0.backgroundColor = .gray200
        }
        contentLabel.do {
            $0.textColor = .gray400
            $0.font = .custom(.bodyLGMedium)
        }
    }
    
    override func setUI() {
        if beforeState == .today {
            super.setUI()
        }
        
        addSubviews(
            checkBox,
            contentLabel
        )
    }
    
    override func setLayout() {
        checkBox.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.adjustedW)
            $0.centerY.equalToSuperview()
        }
        if beforeState == .today {
            super.setLayout()
            
            todayBackgroundView.snp.makeConstraints {
                $0.leading.equalTo(checkBox.snp.trailing).offset(8.adjustedW)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(56.adjustedW)
                $0.height.equalTo(25.adjustedH)
            }
            contentLabel.snp.makeConstraints {
                $0.leading.equalTo(todayBackgroundView.snp.trailing).offset(8.adjustedW)
                $0.centerY.equalToSuperview()
            }
        } else {
            contentLabel.snp.makeConstraints {
                $0.leading.equalTo(checkBox.snp.trailing).offset(8.adjustedW)
                $0.centerY.equalToSuperview()
            }
        }
    }
}

extension CompletedListItem {
    
    func updateText(_ text: String) {
        contentLabel.text = text
    }
}
