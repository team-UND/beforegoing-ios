//
//  ProgressView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/6/25.
//

import UIKit

final class ProgressView: BaseView {
    
    private let indicatorStackView = UIStackView()
    
    override func setStyle() {
        indicatorStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillProportionally
        }
    }
    
    override func setUI() {
        addSubview(indicatorStackView)
        
        OnboardingStep.allCases.forEach { step in
            if step == .end { return }
            let indicator = createIndicator()
            indicatorStackView.addArrangedSubview(indicator)
        }
    }
    
    override func setLayout() {
        indicatorStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(72.adjustedW)
            $0.height.equalTo(8.adjustedH)
        }
    }
    
    private func createIndicator() -> UILabel {
        let indicator = UILabel()
        indicator.do {
            $0.backgroundColor = .gray200
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
        }
        indicator.snp.makeConstraints {
            $0.size.equalTo(8.adjustedW)
        }
        return indicator
    }
}

extension ProgressView {
    
    func updateUI(step: OnboardingStep) {
        if step == .end {
            indicatorStackView.isHidden = true
            return
        }
        
        indicatorStackView.isHidden = false
        let currentIndex = step.rawValue
        
        indicatorStackView.arrangedSubviews.enumerated().forEach { index, view in
            view.backgroundColor = index == currentIndex ? .blue400 : .gray200
        }
    }
}
