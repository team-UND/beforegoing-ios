//
//  OnboardingView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/6/25.
//

import UIKit

final class OnboardingView: BaseView {
    
    private let progressView = ProgressView()
    private let contentView = OnboardingContentView()
    private(set) var bottomButton = CustomButton(state: .enableLongButton, title: "다음")
    
    private var step: OnboardingStep
    
    init(step: OnboardingStep) {
        self.step = step
        super.init(frame: .zero)
        
        requestUpdate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .white
    }
    
    override func setUI() {
        addSubviews(
            progressView,
            contentView,
            bottomButton
        )
    }
    
    override func setLayout() {
        progressView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(8.adjustedH)
        }
        contentView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(55.adjustedH)
            $0.centerX.equalToSuperview()
        }
        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(34.adjustedH)
        }
    }
}

extension OnboardingView {
    
    func updateUI() -> Bool {
        guard let step = OnboardingStep(rawValue: step.rawValue + 1) else { return false }
        
        self.step = step
        requestUpdate()
        return true
    }
    
    private func requestUpdate() {
        progressView.updateUI(step: step)
        contentView.updateUI(step: step)
        bottomButton.setTitle(step.component.buttonTitle, for: .normal)
    }
}
