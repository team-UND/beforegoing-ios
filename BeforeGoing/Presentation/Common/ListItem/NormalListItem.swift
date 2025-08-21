//
//  NormalListItem.swift
//  BeforeGoing
//
//  Created by APPLE on 8/19/25.
//

import UIKit

final class NormalListItem: BaseView, ListItemProtocol {
    
    private(set) var checkBox = CheckBox(currentState: .unchecked)
    private let contentLabel = UILabel()
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 1.4
            $0.layer.borderColor = UIColor.blue50.cgColor
        }
        contentLabel.do {
            $0.textColor = .gray900
            $0.font = .custom(.bodyLGMedium)
        }
    }
    
    override func setUI() {
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
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBox.snp.trailing).offset(8.adjustedW)
            $0.centerY.equalToSuperview()
        }
    }
}

extension NormalListItem {
    
    func updateText(_ text: String) {
        contentLabel.text = text
    }
}
