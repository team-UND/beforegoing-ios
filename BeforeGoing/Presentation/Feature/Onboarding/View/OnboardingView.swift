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
    private lazy var leftSwipeAction: UISwipeGestureRecognizer = {
        let swipeAction = UISwipeGestureRecognizer(
            target: self,
            action: #selector(handleMovingPage(_:))
        )
        swipeAction.do {
            $0.direction = .left
            $0.numberOfTouchesRequired = 1
        }
        return swipeAction
    }()
    private lazy var rightSwipeAction: UISwipeGestureRecognizer = {
        let swipeAction = UISwipeGestureRecognizer(
            target: self,
            action: #selector(handleMovingPage(_:))
        )
        swipeAction.do {
            $0.direction = .right
            $0.numberOfTouchesRequired = 1
        }
        return swipeAction
    }()
    private let transition = CATransition()
    private let timingFunction = CAMediaTimingFunction(name: .easeOut)
    private let contentTransitionKey = "contentTransition"
    private(set) var bottomButton = CustomButton(state: .enableLongButton, title: "시작하기")
    
    private var step: OnboardingStep
    
    init(step: OnboardingStep) {
        self.step = step
        super.init(frame: .zero)
        
        requestUpdate()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .white
        bottomButton.isHidden = true
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
            $0.width.equalTo(72.adjustedW)
            $0.height.equalTo(8.adjustedH)
        }
        contentView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(55.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomButton.snp.top)
        }
        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(34.adjustedH)
        }
    }
    
    private func setAction() {
        self.do {
            $0.addGestureRecognizer(leftSwipeAction)
            $0.addGestureRecognizer(rightSwipeAction)
            $0.isUserInteractionEnabled = true
        }
    }
}

extension OnboardingView {
    
    func moveFront() -> Bool {
        guard let step = OnboardingStep(rawValue: step.rawValue + 1) else { return false }
        
        self.step = step
        bottomButton.isHidden = (step == .end) ? false : true
        requestUpdate(direction: .fromRight)
        return true
    }
    
    private func moveBack() {
        guard let step = OnboardingStep(rawValue: step.rawValue - 1) else { return }
        
        self.step = step
        bottomButton.isHidden = (step == .end) ? false : true
        requestUpdate(direction: .fromLeft)
    }
    
    private func requestUpdate(direction: CATransitionSubtype? = nil) {
        progressView.updateUI(step: step)
        
        if let direction = direction {
            transition.do {
                $0.duration = 0.3
                $0.type = .push
                $0.subtype = direction
                $0.timingFunction = timingFunction
            }
            contentView.layer.add(transition, forKey: contentTransitionKey)
        }
        
        contentView.updateUI(step: step)
    }
}

extension OnboardingView {
    
    @objc
    private func handleMovingPage(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            let _ = moveFront()
        case .right:
            moveBack()
        default:
            break
        }
    }
}
