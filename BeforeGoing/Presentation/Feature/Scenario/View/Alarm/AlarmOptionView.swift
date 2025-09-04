//
//  AlarmOptionView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

final class AlarmOptionView: BaseView {
    
    private let optionType: NoticeOptionType
    private let titleLabel = UILabel()
    private(set) var radioButton: RadioButton
    
    init(type: NoticeOptionType) {
        self.optionType = type
        self.radioButton = type.component.radioButton
        super.init(frame: .zero)
        
        self.titleLabel.text = type.component.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = (optionType == .noNotice) ? .blue100 : .clear
            $0.layer.cornerRadius = 14
            $0.layer.borderColor = (optionType == .noNotice) ? UIColor.blue400.cgColor : UIColor.gray200.cgColor
            $0.layer.borderWidth = 1
        }
        titleLabel.do {
            $0.textColor = .gray900
            $0.font = .custom(.bodyLGMedium)
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            radioButton
        )
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(54.adjustedH)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading).offset(20.adjustedW)
            $0.centerY.equalToSuperview()
        }
        radioButton.snp.makeConstraints {
            $0.trailing.equalTo(self.snp.trailing).offset(-20.adjustedW)
            $0.centerY.equalToSuperview()
        }
    }
}

extension AlarmOptionView {
    
    func updateUI(isSelected: Bool) {
        self.do {
            $0.backgroundColor = isSelected ? .blue100 : .clear
            $0.layer.borderColor = isSelected ? UIColor.blue400.cgColor : UIColor.gray200.cgColor
        }
        radioButton.changeState(isSelected)
    }
    
    func equalTo(_ view: AlarmOptionView) -> Bool {
        return self.titleLabel.text == view.titleLabel.text
    }
}
