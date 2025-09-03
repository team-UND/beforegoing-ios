//
//  ManageScenarioCell.swift
//  BeforeGoing
//
//  Created by APPLE on 8/26/25.
//

import UIKit

final class ManageScenarioCell: UITableViewCell {
        
    override var isSelected: Bool {
        didSet { updateStyle() }
    }
    
    private let containerView = UIView()
    private let templateImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
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
        containerView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.blue50.cgColor
        }
        titleLabel.do {
            $0.textColor = .gray900
            $0.font = .custom(.bodyLGSemiBold)
        }
        subtitleLabel.do {
            $0.textColor = .gray400
            $0.font = .custom(.bodyMDRegular)
        }
    }
    
    private func setUI() {
        contentView.addSubview(containerView)
        containerView.addSubviews(
            templateImageView,
            titleLabel,
            subtitleLabel
        )
    }
    
    private func setLayout() {
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(76.adjustedH)
        }
        templateImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.adjustedW)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24.adjustedW)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.adjustedH)
            $0.leading.equalTo(templateImageView.snp.trailing).offset(8.adjustedW)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(templateImageView.snp.trailing).offset(8.adjustedW)
        }
    }
}

extension ManageScenarioCell {
    
    func bind(type: ScenarioType) {
        templateImageView.image = type.image
        titleLabel.text = type.rawValue
        subtitleLabel.text = type.subtitle
    }
    
    private func updateStyle() {
        containerView.do {
            $0.backgroundColor = isSelected ? .blue50 : .white
            $0.layer.borderColor = isSelected ? UIColor.blue500.cgColor : UIColor.blue50.cgColor
            $0.layer.borderWidth = isSelected ? 1.5 : 1
        }
    }
}
