//
//  HomeHeaderView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/8/25.
//

import UIKit

final class HomeHeaderView: BaseView {
    
    private(set) var dateStackView = UIStackView()
    private let dateLabel = UILabel()
    private(set) var viewCalendarButton = UIButton()
    private let bubbleView = UIView()
    private let wordLabel = UILabel()

    private let path = UIBezierPath()
    private let shadowLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bubbleView.layer.shadowPath = UIBezierPath(
            roundedRect: bubbleView.bounds,
            cornerRadius: bubbleView.layer.cornerRadius
        ).cgPath
    }
    
    override func setStyle() {
        dateStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2.adjustedW
            $0.alignment = .center
        }
        dateLabel.do {
            $0.textColor = .gray600
            $0.textAlignment = .center
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
            $0.font = .custom(.bodyMDRegular)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        path.do {
            let width = 18.adjustedW
            let radius = width / 2

            $0.move(to: CGPoint(x: 0, y: 0))
            $0.addArc(
                withCenter: CGPoint(x: width / 2, y: 0),
                radius: radius,
                startAngle: 0,
                endAngle: .pi,
                clockwise: true
            )
            $0.close()
        }
        shadowLayer.do {
            $0.path = path.cgPath
            $0.fillColor = UIColor.white.cgColor
            $0.strokeColor = UIColor.borderBlue.cgColor
            $0.lineWidth = 1
            $0.shadowColor = UIColor.black.cgColor
            $0.shadowOpacity = 0.1
            $0.shadowOffset = CGSize(width: 0, height: 2)
            $0.shadowRadius = 4
            $0.shadowPath = path.cgPath
            $0.shouldRasterize = true
            $0.rasterizationScale = UIScreen.main.scale
        }
    }
    
    override func setUI() {
        addSubviews(
            dateStackView,
            bubbleView
        )
        dateStackView.addArrangedSubviews(
            dateLabel,
            viewCalendarButton
        )
        bubbleView.addSubview(wordLabel)
    }
    
    override func setLayout() {
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140.adjustedW)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.top)
            $0.leading.equalTo(dateStackView.snp.leading)
            $0.width.equalTo(115.adjustedW)
        }
        viewCalendarButton.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.top)
            $0.trailing.equalTo(dateStackView.snp.trailing)
            $0.size.equalTo(16.adjustedW)
        }
        bubbleView.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(16.adjustedH)
            $0.leading.greaterThanOrEqualToSuperview().inset(20.adjustedW)
            $0.trailing.lessThanOrEqualToSuperview().inset(20.adjustedW)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(62.adjustedH)
        }

        wordLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 8, left: 25, bottom: 8, right: 25)
            )
        }
    }
}

extension HomeHeaderView {
    
    func updateDateUI(date: String) {
        dateLabel.text = date
    }
    
    func updateWeatherUI(information: NSMutableAttributedString) {
        wordLabel.attributedText = information
    }
    
    func updateWeatherUI(information: String) {
        wordLabel.text = information
    }
}
