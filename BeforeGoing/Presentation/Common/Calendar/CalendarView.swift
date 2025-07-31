//
//  CalendarView.swift
//  BeforeGoing
//
//  Created by APPLE on 7/30/25.
//

import UIKit

import SnapKit

final class CalendarView: BaseView {
    
    let headerView = CalendarHeaderView()
    private let weekView = WeekView()
    private let flowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 14
            // TO-DO : border shadow color 추가
        }
        flowLayout.do {
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 24.adjustedH
            $0.itemSize = CGSize(width: (310 / 7).adjustedW, height: 29.adjustedH)
        }
    }
    
    override func setUI() {
        addSubviews(
            headerView,
            weekView,
            collectionView
        )
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(350.adjustedW)
            $0.bottom.equalTo(collectionView.snp.bottom).offset(40.adjustedH)
        }
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
        }
        weekView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(24.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(22.adjustedH)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(weekView.snp.bottom).offset(20.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(300.adjustedH)
        }
    }
}

extension CalendarView {
    
    func configureCollectionView(weeks: Int) {
        let itemHeight = 29.adjustedH
        let spacing = 24.adjustedH
        let totalHeight = itemHeight * CGFloat(weeks) + spacing * CGFloat(weeks - 1)
        
        collectionView.snp.updateConstraints {
            $0.height.equalTo(totalHeight)
        }
    }
}
