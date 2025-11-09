//
//  TodayListItemComponentView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/23/25.
//

import UIKit

class TodayListItemComponentView: BaseView {
    
    let todayBackgroundView = UIView()
    let todayLabelBackgroundGradient = CAGradientLayer()
    let todayLabel = UILabel()
    let expressTodayView = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        todayLabelBackgroundGradient.frame = todayBackgroundView.bounds
    }
    
    override func setStyle() {
        todayBackgroundView.do {
            $0.layer.borderColor = UIColor.blue200.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 12.5
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
            $0.layer.cornerRadius = 25
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            $0.layer.borderWidth = 1.4
            $0.layer.borderColor = UIColor.blue50.cgColor
            $0.clipsToBounds = true
        }
    }
    
    override func setUI() {
        addSubviews(
            todayBackgroundView,
            expressTodayView
        )
        todayBackgroundView.addSubview(todayLabel)
    }
    
    override func setLayout() {
        todayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        expressTodayView.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(10.adjustedW)
            $0.height.equalTo(50.adjustedH)
        }
    }
}
