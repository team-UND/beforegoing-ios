//
//  ModalView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/5/25.
//

import UIKit

final class ModalView: BaseView {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let buttonStackView = UIStackView()
    private(set) var dismissButton = UIButton()
    private(set) var actionButton = UIButton()
    
    init(type: ModalType) {
        super.init(frame: .zero)
        
        let component = type.component
        imageView.image = component.image
        titleLabel.text = component.mainTitle
        descriptionLabel.text = component.description
        dismissButton.setTitle(component.dismissTitle, for: .normal)
        actionButton.setTitle(component.actionTitle, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .white
        self.layer.do {
            $0.cornerRadius = 14
            $0.shadowColor = UIColor.blue500.cgColor
            $0.shadowOpacity = 0.5
            $0.shadowRadius = 1
            $0.shadowOffset = .zero
            $0.shadowPath = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: layer.cornerRadius
            ).cgPath
        }
        titleLabel.do {
            $0.textColor = .gray900
            $0.textAlignment = .center
            $0.font = .custom(.headingH5)
        }
        descriptionLabel.do {
            $0.textColor = .gray400
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = .custom(.bodyMDMedium)
        }
        buttonStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
        }
        dismissButton.do {
            $0.backgroundColor = .clear
            $0.setTitleColor(.gray600, for: .normal)
            $0.titleLabel?.font = .custom(.bodyLGSemiBold)
        }
        actionButton.do {
            $0.backgroundColor = .clear
            $0.setTitleColor(.warning600, for: .normal)
            $0.titleLabel?.font = .custom(.bodyLGSemiBold)
        }
    }
    
    override func setUI() {
        addSubviews(
            imageView,
            titleLabel,
            descriptionLabel,
            buttonStackView
        )
        buttonStackView.addArrangedSubviews(
            dismissButton,
            actionButton
        )
    }
    
    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.adjustedH)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(120.adjustedW)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4.adjustedH)
            $0.centerX.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(4.adjustedH)
            $0.height.equalTo(48.adjustedH)
        }
    }
}
