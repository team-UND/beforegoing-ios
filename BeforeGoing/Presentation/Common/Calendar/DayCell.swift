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
            // TO-DO : 블러 처리
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
            } else if isToday {
                dayLabel.do {
                    $0.textColor = .blue700
                    $0.font = .custom(.bodyLGMedium)
                }
                blurView.isHidden = true
            } else {
                dayLabel.do {
                    $0.textColor = .gray500
                    $0.font = .custom(.bodyLGRegular)
                }
                blurView.isHidden = true
            }
        }
    }
}
