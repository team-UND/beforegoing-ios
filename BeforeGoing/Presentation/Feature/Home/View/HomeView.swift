//
//  HomeView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/11/25.
//

import UIKit

final class HomeView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private(set) var headerView = HomeHeaderView()
    private(set) var modalView = UserScenarioModalView()
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgHome
            $0.contentMode = .scaleAspectFit
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            headerView,
            modalView
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(200.adjustedH)
        }
        modalView.snp.makeConstraints {
            $0.height.equalTo(modalView.maxHeight)
            $0.leading.trailing.equalToSuperview()
            modalView.bottomConstraint =
            $0.bottom.equalToSuperview().offset(modalView.maxHeight - modalView.minHeight).constraint
        }

    }
}
