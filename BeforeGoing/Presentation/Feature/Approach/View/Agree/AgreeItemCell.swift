//
//  AgreeItemCell.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import UIKit

final class AgreeItemCell: UITableViewCell {
    
    private let checkBox = CheckBox()
    private let titleLabel = UILabel()
    private let isNecessaryLabel = UILabel()
    private(set) var goToSettingButton = UIButton()
    
    var onCheckBoxDidTap: ((CheckBoxState) -> Void)?
    var onTermDidTap: (() -> Void)?
    var onPrivacyDidTap: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        selectionStyle = .none
        titleLabel.do {
            $0.textColor = .gray900
            $0.font = .custom(.bodyLGMedium)
        }
        isNecessaryLabel.do {
            $0.font = .custom(.bodyLGRegular)
        }
        goToSettingButton.do {
            $0.setImage(
                .chevronRight.withTintColor(.gray400),
                for: .normal
            )
            $0.isHidden = true
        }
    }
    
    private func setUI() {
        contentView.addSubviews(
            checkBox,
            titleLabel,
            isNecessaryLabel,
            goToSettingButton
        )
    }
    
    private func setLayout() {
        checkBox.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBox.snp.trailing).offset(8.adjustedW)
            $0.centerY.equalTo(checkBox.snp.centerY)
        }
        isNecessaryLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4.adjustedW)
            $0.centerY.equalTo(checkBox.snp.centerY)
        }
        goToSettingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(checkBox.snp.centerY)
            $0.size.equalTo(24.adjustedW)
        }
    }
    
    private func setAction() {
        setGesture()
        checkBox.addTarget(self, action: #selector(checkBoxDidTap), for: .touchUpInside)
    }
    
    private func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkBoxDidTap))
        titleLabel.do {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGesture)
        }
    }
}

extension AgreeItemCell {
    
    func bind(item: AgreeItem, checkBoxState: CheckBoxState) {
        bindData(item: item)
        bindCheckBox(state: checkBoxState)
    }
    
    private func bindData(item: AgreeItem) {
        let component = item.component
        
        titleLabel.text = component.text.rawValue
        if component.isNecessary {
            isNecessaryLabel.do {
                $0.text = "(필수)"
                $0.textColor = .blue700
            }
        } else {
            isNecessaryLabel.do {
                $0.text = "(선택)"
                $0.textColor = .gray400
            }
        }
        goToSettingButton.isHidden = !component.canMoveToExternal
        
        switch component.text {
        case .termsOfServiceAgreed:
            goToSettingButton.addTarget(
                self,
                action: #selector(termsOfServiceDidTap),
                for: .touchUpInside
            )
        case .privacyPolicyAgreed:
            goToSettingButton.addTarget(
                self,
                action: #selector(privacyDidTap),
                for: .touchUpInside
            )
        default:
            break
        }
    }
    
    private func bindCheckBox(state: CheckBoxState) {
        checkBox.updateState(state)
    }
}

extension AgreeItemCell {
    
    @objc
    private func checkBoxDidTap() {
        onCheckBoxDidTap?(checkBox.toggle())
    }
    
    @objc
    private func termsOfServiceDidTap() {
        onTermDidTap?()
    }
    
    @objc
    private func privacyDidTap() {
        onPrivacyDidTap?()
    }
}
