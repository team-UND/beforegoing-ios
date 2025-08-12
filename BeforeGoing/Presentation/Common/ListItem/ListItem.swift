//
//  ListItem.swift
//  BeforeGoing
//
//  Created by APPLE on 8/12/25.
//

import UIKit

final class ListItem: UIView {
    
    private let state: ListItemState
    
    private let checkBox = CheckBox(currentState: .unchecked)
    private let todayLabel = UILabel()
    private let todayBackgroundView = UIView()
    private let todayLabelBackgroundGradient = CAGradientLayer()
    private let contentLabel = UILabel()
    private let expressTodayView = UIView()
    
    init(state: ListItemState) {
        self.state = state
        super.init(frame: .zero)
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        todayLabelBackgroundGradient.frame = todayBackgroundView.bounds
    }
    
    private func setStyle() {
        self.do {
            $0.backgroundColor = .white
            $0.layer.borderColor = UIColor.blue50.cgColor
            $0.layer.borderWidth = 1.4
            $0.layer.cornerRadius = 14
        }
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
        contentLabel.do {
            $0.text = "가스불 끄기"
            $0.textColor = .gray900
            $0.font = .custom(.bodyLGMedium)
        }
        expressTodayView.do {
            $0.backgroundColor = .blue50
            $0.roundCorners(
                corners: [.topLeft, .bottomLeft],
                radius: 14
            )
        }
    }
    
    private func setUI() {
        todayBackgroundView.addSubview(todayLabel)
        addSubviews(
            checkBox,
            todayBackgroundView,
            contentLabel,
            expressTodayView
        )
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(50.adjustedH)
        }
        checkBox.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.adjustedW)
            $0.centerY.equalToSuperview()
        }
        if state.isToday {
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
            }
            return
        }
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBox.snp.trailing).offset(8.adjustedW)
            $0.centerY.equalToSuperview()
        }
    }
}
