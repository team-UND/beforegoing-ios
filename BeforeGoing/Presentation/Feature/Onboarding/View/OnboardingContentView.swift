//
//  OnboardingContentView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/6/25.
//

import UIKit

final class OnboardingContentView: BaseView {
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    
    override func setStyle() {
        titleLabel.do {
            $0.textColor = .gray900
            $0.font = .custom(.headingH4)
            $0.textAlignment = .center
        }
        descriptionLabel.do {
            $0.textColor = .gray400
            $0.font = .custom(.bodyLGMedium)
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            descriptionLabel,
            imageView
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
}

extension OnboardingContentView {
    
    func updateUI(step: OnboardingStep) {
        let component = step.component
        
        titleLabel.text = component.title
        descriptionLabel.text = component.description
        imageView.image = component.image
        
        setImageLayout(step: step)
    }
    
    private func setImageLayout(step: OnboardingStep) {
        imageView.snp.makeConstraints {
            switch step {
            case .first, .end:
                $0.top.equalTo(safeAreaLayoutGuide.snp.bottom).offset(213.adjustedH)
                $0.centerX.equalToSuperview()
                $0.size.equalTo(260.adjustedH)
            case .second, .third, .fourth, .fifth:
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(34.adjustedH)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
}
