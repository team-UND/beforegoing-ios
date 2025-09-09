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
        
        setLayout(step: step)
    }
    
    private func setLayout(step: OnboardingStep) {
        switch step {
        case .first, .end:
            titleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.centerX.equalToSuperview()
            }
            descriptionLabel.snp.remakeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(8.adjustedH)
                $0.centerX.equalToSuperview()
            }
            imageView.snp.remakeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(94.adjustedH)
                $0.centerX.equalToSuperview()
                $0.size.equalTo(260.adjustedH)
            }
        case .second, .third, .fourth, .fifth:
            titleLabel.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.height.equalTo(26.adjustedH)
            }
            descriptionLabel.snp.remakeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(8.adjustedH)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(44.adjustedH)
            }
            imageView.snp.remakeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(34.adjustedH)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(292.adjustedW)
                $0.height.equalTo(607.adjustedH)
            }
        }
    }
}
