//
//  ScenarioListView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/24/25.
//

import UIKit

final class ScenarioListView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let topNavigationView = TopNavigationView(title: "MY 시나리오")
    private(set) var addScenarioButton = CustomButton(state: .addScenarioButton, title: "+ 시나리오 추가")
    private(set) var scenarioListTableView = UITableView()
    
    override func setStyle() {
        backgroundImageView.image = .bgTop
        scenarioListTableView.do {
            $0.separatorStyle = .none
            $0.dragInteractionEnabled = true
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            topNavigationView,
            addScenarioButton,
            scenarioListTableView
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        topNavigationView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48.adjustedH)
        }
        addScenarioButton.snp.makeConstraints {
            $0.top.equalTo(topNavigationView.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
        }
        scenarioListTableView.snp.makeConstraints {
            $0.top.equalTo(addScenarioButton.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview()
        }
    }
}
