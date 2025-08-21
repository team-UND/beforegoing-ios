//
//  CompletedListItem.swift
//  BeforeGoing
//
//  Created by APPLE on 8/19/25.
//

import UIKit

final class CompletedListItem: BaseView, ListItemProtocol {
    
    private(set) var checkBox = CheckBox(currentState: .unchecked)
    private let contentLabel = UILabel()
    
    private let todayBackgroundView = UIView()
    private let todayLabelBackgroundGradient = CAGradientLayer()
    private let todayLabel = UILabel()
    private let expressTodayView = UIView()
    
    private let beforeState: ListItemState
    
    init(beforeState: ListItemState) {
        self.beforeState = beforeState
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if beforeState == .today {
            todayLabelBackgroundGradient.frame = todayBackgroundView.bounds
        }
    }
    
    override func setStyle() {
        self.do {
            $0.checkBox.setImage(.completed, for: .normal)
            $0.checkBox.backgroundColor = .clear
            $0.checkBox.layer.borderWidth = 0
            $0.checkBox.isEnabled = false
            $0.layer.cornerRadius = 14
            $0.backgroundColor = .gray200
        }
        contentLabel.do {
            $0.textColor = .gray400
            $0.font = .custom(.bodyLGMedium)
        }
        
        if beforeState == .today {
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
                $0.layer.cornerRadius = 14
                $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                $0.layer.borderWidth = 1.4
                $0.layer.borderColor = UIColor.blue50.cgColor
            }
        }
    }
    
    override func setUI() {
        addSubviews(
            checkBox,
            contentLabel
        )
        if beforeState == .today {
            todayBackgroundView.addSubview(todayLabel)
            addSubviews(
                todayBackgroundView,
                expressTodayView
            )
        }
    }
    
    override func setLayout() {
        checkBox.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.adjustedW)
            $0.centerY.equalToSuperview()
        }
        if beforeState == .normal {
            contentLabel.snp.makeConstraints {
                $0.leading.equalTo(checkBox.snp.trailing).offset(8.adjustedW)
                $0.centerY.equalToSuperview()
            }
        } else {
            todayBackgroundView.snp.makeConstraints {
                $0.leading.equalTo(checkBox.snp.trailing).offset(8.adjustedW)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(56.adjustedW)
                $0.height.equalTo(25.adjustedH)
            }
            todayLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            contentLabel.snp.makeConstraints {
                $0.leading.equalTo(todayBackgroundView.snp.trailing).offset(8.adjustedW)
                $0.centerY.equalToSuperview()
            }
            expressTodayView.snp.makeConstraints {
                $0.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.width.equalTo(10.adjustedW)
                $0.height.equalTo(53.adjustedH)
            }
        }
    }
}

extension CompletedListItem {
    
    func updateText(_ text: String) {
        contentLabel.text = text
    }
}
