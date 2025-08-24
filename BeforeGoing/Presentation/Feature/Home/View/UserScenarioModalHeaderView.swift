//
//  UserScenarioModalHeaderView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/13/25.
//

import UIKit

final class UserScenarioModalHeaderView: BaseView {
    
    // 실제 데이터로 대체
    private let scenarios = ["출근 전", "외출 전", "운동 전", "요리하기 전", "나가기 전"]
    
    private let scenarioStackView = UIStackView()
    private let scenarioScrollView = UIScrollView()
    private let addScenarioView = UIView()
    private let addScenarioButton = UIButton()
    
    override func setStyle() {
        scenarioScrollView.do {
            $0.showsHorizontalScrollIndicator = false
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        scenarioStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .fill
        }
        addScenarioView.do {
            $0.backgroundColor = .white
        }
        addScenarioButton.do {
            $0.setImage(.plusCircle.withTintColor(.gray900), for: .normal)
        }
        scenarios.forEach {
            scenarioStackView.addArrangedSubview(createScenarioItem(title: $0))
        }
        if let firstContainer = scenarioStackView.arrangedSubviews.first,
           let firstLabel = firstContainer.subviews.compactMap({ $0 as? UILabel }).first {
            manageTappedLabel(firstLabel)
            manageNotTappedLabel(firstLabel)
        }
    }
    
    override func setUI() {
        scenarioScrollView.addSubview(scenarioStackView)
        addScenarioView.addSubview(addScenarioButton)
        addSubviews(
            scenarioScrollView,
            addScenarioView
        )
    }
    
    override func setLayout() {
        scenarioScrollView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(42.adjustedH)
            $0.trailing.equalTo(addScenarioView.snp.leading)
        }
        scenarioStackView.snp.makeConstraints {
            $0.edges.equalTo(scenarioScrollView.contentLayoutGuide)
            $0.height.equalTo(scenarioScrollView.frameLayoutGuide)
        }
        addScenarioView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.equalTo(56.adjustedW)
            $0.height.equalTo(42.adjustedH)
        }
        addScenarioButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(16.adjustedW)
        }
    }
}

extension UserScenarioModalHeaderView {
    
    private func createScenarioItem(title: String) -> UIView {
        let containerView = UIView()
        let scenarioLabel = createScenarioLabel(title: title)
        let selectBar = createSelectBar()
        
        containerView.addSubviews(
            scenarioLabel,
            selectBar
        )
        makeScenarioItemConstraint(
            containerView,
            scenarioLabel,
            selectBar
        )
        
        return containerView
    }
    
    
    private func createScenarioLabel(title: String) -> UILabel {
        let scenarioLabel = UILabel()
        let scenario = title
        scenarioLabel.do {
            $0.text = scenario
            $0.textColor = .gray400
            $0.textAlignment = .center
            $0.font = .custom(.bodyMDSemiBold)
            $0.isUserInteractionEnabled = true
        }
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(scenarioTapped(_:))
        )
        scenarioLabel.addGestureRecognizer(tapGesture)
        return scenarioLabel
    }
    
    private func createSelectBar() -> UILabel {
        let selectBarLabel = UILabel()
        selectBarLabel.do {
            $0.backgroundColor = .blue400
            $0.layer.borderColor = UIColor.blue400.cgColor
            $0.layer.borderWidth = 2
            $0.isHidden = true
        }
        return selectBarLabel
    }
    
    private func makeScenarioItemConstraint(
        _ containerView: UIView,
        _ scenarioLabel: UILabel,
        _ selectBar: UILabel
    ) {
        scenarioLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(40.adjustedH)
        }
        selectBar.snp.makeConstraints {
            $0.top.equalTo(scenarioLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(2.adjustedH)
        }
        containerView.snp.makeConstraints {
            $0.width.equalTo(83.5.adjustedW)
            $0.height.equalTo(42.adjustedH)
        }
    }
}

extension UserScenarioModalHeaderView {
    
    @objc
    private func scenarioTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        manageTappedLabel(label)
        manageNotTappedLabel(label)
    }
    
    private func manageTappedLabel(_ label: UILabel) {
        scenarioStackView.arrangedSubviews.forEach { container in
            if let tappedlabel = container.subviews.compactMap({ $0 as? UILabel }).first,
               tappedlabel != label {
                tappedlabel.textColor = .gray400
                if let bar = container.subviews.last as? UILabel {
                    bar.isHidden = true
                }
            }
        }
    }
    
    private func manageNotTappedLabel(_ label: UILabel) {
        label.textColor = .gray900
        if let container = label.superview,
           let bar = container.subviews.last as? UILabel {
            bar.isHidden = false
        }
    }
}
