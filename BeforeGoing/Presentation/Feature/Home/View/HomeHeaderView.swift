//
//  HomeHeaderView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/8/25.
//

import UIKit

final class HomeHeaderView: BaseView {
    
    private let dateStacView = UIStackView()
    private let dateLabel = UILabel()
    private(set) var viewCalendarButton = UIButton()
    private let bubbleView = UIView()
    private let wordLabel = UILabel()
    private let tipView = UIView()
    private let circleView = UIView()
    
    override func setStyle() {
        dateStacView.do {
            $0.axis = .horizontal
            $0.spacing = 2.adjustedW
            $0.alignment = .center
        }
        dateLabel.do {
            // 날짜 뷰컨에서 받아오기
            $0.text = "2025년 8월 15일"
            $0.textColor = .gray600
            $0.font = .custom(.bodyMDSemiBold)
        }
        viewCalendarButton.do {
            $0.setImage(.chevronDown.withTintColor(.gray600), for: .normal)
        }
        bubbleView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 35
            $0.layer.borderColor = UIColor.borderBlue.cgColor
            $0.layer.borderWidth = 1
            $0.layer.shadowColor = $0.layer.borderColor
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowOffset = CGSize(width: 2, height: 2)
            $0.layer.shadowRadius = 4
        }
        wordLabel.do {
            $0.text = "서울시 날씨 좋은데?"
            $0.font = .custom(.bodyMDRegular)
        }
        tipView.do {
            $0.backgroundColor = .white

            let width = 18.adjustedW
            let height = 18.adjustedH
            let radius = width / 2

            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addArc(
                withCenter: CGPoint(x: width / 2, y: 0),
                radius: radius,
                startAngle: 0,
                endAngle: .pi,
                clockwise: true
            )
            path.close()

            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
            shapeLayer.fillColor = UIColor.white.cgColor
            shapeLayer.strokeColor = UIColor.borderBlue.cgColor
            shapeLayer.lineWidth = 1
            $0.layer.addSublayer(shapeLayer)
        }
        circleView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 4
            $0.layer.borderColor = UIColor.borderBlue.cgColor
            $0.layer.borderWidth = 1
            $0.layer.shadowColor = $0.layer.borderColor
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowOffset = CGSize(width: 2, height: 2)
            $0.layer.shadowRadius = 4
            $0.layer.masksToBounds = false
        }
    }
    
    override func setUI() {
        dateStacView.addArrangedSubviews(
            dateLabel,
            viewCalendarButton
        )
        bubbleView.addSubview(wordLabel)
        addSubviews(
            dateStacView,
            bubbleView,
            tipView,
            circleView
        )
    }
    
    override func setLayout() {
        dateStacView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120.adjustedW)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(dateStacView.snp.top)
            $0.leading.equalTo(dateStacView.snp.leading)
        }
        viewCalendarButton.snp.makeConstraints {
            $0.top.equalTo(dateStacView.snp.top)
            $0.trailing.equalTo(dateStacView.snp.trailing)
        }
        bubbleView.snp.makeConstraints {
            $0.top.equalTo(dateStacView.snp.bottom).offset(16.adjustedH)
            $0.leading.equalToSuperview().inset(30.adjustedW)
            $0.trailing.equalToSuperview().inset(20.adjustedW)
            $0.width.equalTo(334.adjustedW)
            $0.height.equalTo(62.adjustedH)
        }
        wordLabel.snp.makeConstraints {
            $0.center.equalTo(bubbleView.snp.center)
        }
        tipView.snp.makeConstraints {
            $0.top.equalTo(bubbleView.snp.top).offset(62.adjustedH)
            $0.leading.equalToSuperview().inset(90.adjustedW)
        }
        circleView.snp.makeConstraints {
            $0.top.equalTo(tipView.snp.bottom).offset(12.adjustedH)
            $0.leading.equalToSuperview().inset(85.adjustedW)
            $0.size.equalTo(8.adjustedW)
        }
    }
}
