//
//  InputInformationView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/1/25.
//

import UIKit

final class InputInformationView: BaseView {
    
    private let titleLabel = UILabel()
    private(set) var letterCountLabel = UILabel()
    private(set) var textField = TextField(type: .settingField)
    private(set) var deleteButton = UIButton()
    
    private let maxLength: Int
    
    var onTextChange: ((String) -> Void)?
    
    init(title: String, maxLength: Int) {
        self.maxLength = maxLength
        super.init(frame: .zero)
        self.titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        titleLabel.do {
            $0.textColor = .gray600
            $0.textAlignment = .left
            $0.font = .custom(.bodyLGMedium)
        }
        letterCountLabel.do {
            $0.textColor = .gray400
            $0.font = .custom(.bodyMDMedium)
            self.letterCountLabel.text = "0/\(maxLength)"
        }
        textField.do {
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.height))
            $0.leftViewMode = .always
        }
        deleteButton.do {
            $0.setImage(.union, for: .normal)
            $0.isHidden = true
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            letterCountLabel,
            textField,
            deleteButton
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        letterCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        deleteButton.snp.makeConstraints {
            $0.trailing.equalTo(textField.snp.trailing).offset(-15.adjustedW)
            $0.centerY.equalTo(textField.snp.centerY)
            $0.size.equalTo(24.adjustedW)
        }
    }
}

extension InputInformationView {
    
    func trimText(_ text: String) -> String {
        let trimmedText = text
            .trim(limit: maxLength)
            .removeLeadingSpaces()
        if text != trimmedText {
            self.textField.text = trimmedText
        }
        return trimmedText
    }
    
    func updateTextCount(_ count: Int) {
        letterCountLabel.text = "\(count)/\(maxLength)"
    }
    
    func deleteAllText() {
        guard let text = textField.text else { return }
        textField.text = ""
        updateTextCount(text.count)
        hideDeleteButton()
    }
    
    func hideDeleteButton() {
        deleteButton.isHidden = true
    }
    
    func revealDeleteButton() {
        deleteButton.isHidden = false
    }
}
