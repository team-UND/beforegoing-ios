//
//  ScenarioListItemView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/24/25.
//

import UIKit

final class ScenarioListItemCell: UITableViewCell {
    
    private let background = UIView()
    private let dragButton = UIButton()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let labelView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.selectionStyle = .none
        background.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.blue50.cgColor
        }
        dragButton.do {
            $0.setImage(.menu.withTintColor(.gray400), for: .normal)
        }
        titleLabel.do {
            $0.textColor = .gray900
            $0.font = .custom(.bodyLGSemiBold)
        }
        subtitleLabel.do {
            $0.textColor = .gray400
            $0.font = .custom(.bodyMDRegular)
        }
        labelView.do {
            $0.backgroundColor = .blue50
            $0.layer.cornerRadius = 14
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.blue50.cgColor
            $0.clipsToBounds = true
        }
    }
    
    private func setUI() {
        addSubview(background)
        background.addSubviews(
            dragButton,
            titleLabel,
            subtitleLabel,
            labelView
        )
    }
    
    private func setLayout() {
        background.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(76.adjustedH)
        }
        dragButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.adjustedW)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24.adjustedW)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.adjustedH)
            $0.leading.equalTo(dragButton.snp.trailing).offset(12.adjustedW)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(dragButton.snp.trailing).offset(12.adjustedW)
        }
        labelView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.width.equalTo(12.adjustedW)
            $0.height.equalTo(76.adjustedH)
        }
    }
}

extension ScenarioListItemCell {
    
    func bind(type: ScenarioType) {
        titleLabel.text = type.rawValue
        subtitleLabel.text = type.subtitle
    }
}
