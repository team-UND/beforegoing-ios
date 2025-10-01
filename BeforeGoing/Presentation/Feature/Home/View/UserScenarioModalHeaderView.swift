//
//  UserScenarioModalHeaderView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/13/25.
//

import UIKit

final class UserScenarioModalHeaderView: BaseView {
    
    private(set) var scenarioStackView = UIStackView()
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
        }
        addScenarioView.do {
            $0.backgroundColor = .white
        }
        addScenarioButton.do {
            $0.setImage(.plusCircle.withTintColor(.gray900), for: .normal)
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
    
    func clear() {
        scenarioStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func createScenarioItem(
        title: String,
        tag: Int,
        tapGesture: UITapGestureRecognizer
    ) {
        let containerView = UIView()
        let scenarioLabel = createScenarioLabel(
            title: title,
            tag: tag,
            tapGesture: tapGesture
        )
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
        tag == 0 ? manageTappedLabel(scenarioLabel) : manageNotTappedLabel(scenarioLabel)
        scenarioStackView.addArrangedSubview(containerView)
    }
    
    
    private func createScenarioLabel(
        title: String,
        tag: Int,
        tapGesture: UITapGestureRecognizer
    ) -> UILabel {
        let scenarioLabel = UILabel()
        let scenario = title
        scenarioLabel.do {
            $0.text = scenario
            $0.textColor = .gray400
            $0.textAlignment = .center
            $0.font = .custom(.bodyMDSemiBold)
            $0.tag = tag
            $0.addGestureRecognizer(tapGesture)
            $0.isUserInteractionEnabled = true
        }
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
            $0.horizontalEdges.equalToSuperview().inset(12.adjustedW)
            $0.height.equalTo(40.adjustedH)
        }
        selectBar.snp.makeConstraints {
            $0.top.equalTo(scenarioLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(2.adjustedH)
        }
        containerView.snp.makeConstraints {
            $0.height.equalTo(42.adjustedH)
        }
    }
}

extension UserScenarioModalHeaderView {
    
    func updateTappedLabel(tag: Int) {
        scenarioStackView.arrangedSubviews.forEach {
            guard let label = $0.subviews.first as? UILabel else {
                return
            }
            label.tag == tag ? manageTappedLabel(label) : manageNotTappedLabel(label)
        }
    }
    
    private func manageTappedLabel(_ label: UILabel) {
        label.textColor = .gray900
        
        if let container = label.superview,
           let bar = container.subviews.last as? UILabel {
            bar.do {
                $0.backgroundColor = .blue400
                $0.layer.borderColor = UIColor.blue400.cgColor
                $0.layer.borderWidth = 2
                $0.isHidden = false
            }
        }
    }
    
    private func manageNotTappedLabel(_ label: UILabel) {
        label.textColor = .gray400
        
        if let container = label.superview,
           let bar = container.subviews.last as? UILabel {
            bar.do {
                $0.backgroundColor = .clear
                $0.layer.borderColor = UIColor.clear.cgColor
                $0.layer.borderWidth = 0
                $0.isHidden = true
            }
        }
    }
}
