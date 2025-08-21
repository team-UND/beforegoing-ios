//
//  DayCell.swift
//  BeforeGoing
//
//  Created by APPLE on 7/30/25.
//

import UIKit

enum DayCellState {
    case notInMonth
    case notSelectable(day: Int)
    case normal(day: Int, isSelected: Bool, isToday: Bool)
}

final class DayCell: UICollectionViewCell {
    
    private let dayLabel = UILabel()
    private let blurView = UIView()
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        dayLabel.textAlignment = .center
        blurView.do {
            $0.backgroundColor = .blue600
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 14.5
            $0.isHidden = true
        }
        gradientLayer.do {
            $0.type = .radial
            $0.colors = [
                UIColor.blue600.cgColor,
                UIColor.blue200.cgColor
            ]
            $0.startPoint = CGPoint(x: 0.5, y: 0.5)
            $0.endPoint = CGPoint(x: 1, y: 1)
        }
    }
    
    private func setUI() {
        contentView.addSubviews(
            blurView,
            dayLabel
        )
    }
    
    private func setLayout() {
        blurView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(29.adjustedW)
        }
        dayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.do {
            $0.text = ""
            $0.font = .custom(.bodyLGRegular)
        }
        blurView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = blurView.bounds
        gradientLayer.cornerRadius = blurView.layer.cornerRadius
    }
}

extension DayCell: ReuseIdentifiable {}

extension DayCell {
    
    func bind(state: DayCellState) {
        switch state {
        case .notInMonth:
            prepareForReuse()
        case let .notSelectable(day):
            dayLabel.do {
                $0.text = "\(day)"
                $0.textColor = .gray300
                $0.font = .custom(.bodyLGRegular)
            }
            blurView.isHidden = true
        case let .normal(day, isSelected, isToday):
            dayLabel.text = "\(day)"
            if isSelected {
                dayLabel.do {
                    $0.textColor = .white
                    $0.font = .custom(.bodyLGMedium)
                }
                blurView.isHidden = false
                if gradientLayer.superlayer == nil {
                    blurView.layer.insertSublayer(gradientLayer, at: 0)
                }
            } else if isToday {
                dayLabel.do {
                    $0.textColor = .blue700
                    $0.font = .custom(.bodyLGMedium)
                }
                blurView.isHidden = true
                gradientLayer.removeFromSuperlayer()
            } else {
                dayLabel.do {
                    $0.textColor = .gray500
                    $0.font = .custom(.bodyLGRegular)
                }
                blurView.isHidden = true
                gradientLayer.removeFromSuperlayer()
            }
        }
    }
}
