//
//  ListItem.swift
//  BeforeGoing
//
//  Created by APPLE on 8/12/25.
//

import UIKit

final class ListItem: UIView {
    
    private var state: ListItemState {
        didSet {
            if state == .completed {
                setStyle()
                setLayout()
            }
        }
    }
    
    private var checkBox = CheckBox(currentState: .unchecked)
    private let todayLabel = UILabel()
    private let todayBackgroundView = UIView()
    private let todayLabelBackgroundGradient = CAGradientLayer()
    private let contentLabel = UILabel()
    private let expressTodayView = UIView()
    private let completedImageView = UIImageView()
    
    init?(state: ListItemState, title: String) {
        if state == .completed { return nil }
        
        self.state = state
        self.contentLabel.text = title
        super.init(frame: .zero)
        
        setStyle()
        setUI()
        setLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        todayLabelBackgroundGradient.frame = todayBackgroundView.bounds
        expressTodayView.roundCorners(
            corners: [.topRight, .bottomRight],
            radius: 14
        )
    }
    
    private func setStyle() {
        switch state {
        case .original:
            setBasicElementStyle()
        case .today:
            setBasicElementStyle()
            setTodayStyle()
        case .completed:
            setCompletedStyle()
        }
    }
    
    private func setBasicElementStyle() {
        self.do {
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.blue50.cgColor
            $0.layer.borderWidth = 1.4
            $0.layer.cornerRadius = 14
            $0.clipsToBounds = true
        }
        contentLabel.do {
            $0.textColor = .gray900
            $0.font = .custom(.bodyLGMedium)
        }
    }
    
    private func setTodayStyle() {
        todayBackgroundView.do {
            $0.layer.borderColor = UIColor.blue200.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
        }
        todayLabel.do {
            $0.text = "Today"
            $0.textColor = .blue500
            $0.textAlignment = .center
            $0.font = .custom(.bodyMDSemiBold)
        }
        todayLabelBackgroundGradient.do {
            $0.colors = [
                UIColor.bgGradationStart.cgColor,
                UIColor.bgGradationEnd.cgColor
            ]
            $0.startPoint = CGPoint(x: 0, y: 0.5)
            $0.endPoint = CGPoint(x: 1, y: 0.5)
            todayBackgroundView.layer.insertSublayer($0, at: 0)
        }
        expressTodayView.do {
            $0.backgroundColor = .blue50
        }
    }
    
    private func setCompletedStyle() {
        self.do {
            $0.backgroundColor = .gray200
            $0.layer.cornerRadius = 14
            $0.layer.borderWidth = 0
        }
        checkBox.isHidden = true
        completedImageView.do {
            $0.image = .completed
        }
        contentLabel.do {
            $0.textColor = .gray400
            $0.font = .custom(.bodyLGMedium)
        }
    }
    
    private func setUI() {
        todayBackgroundView.addSubview(todayLabel)
        addSubviews(
            checkBox,
            todayBackgroundView,
            contentLabel,
            expressTodayView,
            completedImageView
        )
    }
    
    private func setLayout() {
        setBasicElemntLayout()
        switch state {
        case .today: setTodayLayout()
        case .completed: setCompletedLayout()
        case .original:  break
        }
    }
    
    private func setBasicElemntLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(50.adjustedH)
        }
        checkBox.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.adjustedW)
            $0.centerY.equalToSuperview()
        }
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBox.snp.trailing).offset(8.adjustedW)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setTodayLayout() {
        todayBackgroundView.snp.makeConstraints {
            $0.leading.equalTo(checkBox.snp.trailing).offset(8.adjustedW)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(56.adjustedW)
            $0.height.equalTo(25.adjustedH)
        }
        todayLabel.snp.makeConstraints {
            $0.center.equalTo(todayBackgroundView.snp.center)
        }
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(todayBackgroundView.snp.trailing).offset(8.adjustedW)
            $0.centerY.equalToSuperview()
        }
        expressTodayView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(10.adjustedW)
            $0.height.equalTo(50.adjustedH)
        }
    }
    
    private func setCompletedLayout() {
        completedImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.adjustedW)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setAction() {
        checkBox.addTarget(self, action: #selector(checkBoxDidTap), for: .touchUpInside)
    }
}

extension ListItem {
    
    @objc
    func checkBoxDidTap() {
        self.state = .completed
    }
}
