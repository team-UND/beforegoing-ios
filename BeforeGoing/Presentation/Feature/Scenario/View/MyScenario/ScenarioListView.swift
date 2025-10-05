//
//  ScenarioListView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/24/25.
//

import UIKit

final class ScenarioListView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let titleLabel = UILabel()
    private(set) var addScenarioButton = CustomButton(state: .addScenarioButton, title: "+ 시나리오 추가")
    private let emptyView = ScenarioEmptyView(type: .myScenario)
    private(set) var scenarioListTableView = UITableView()
    
    override func setStyle() {
        backgroundImageView.image = .bgTop
        titleLabel.do {
            $0.text = "MY 시나리오"
            $0.font = .custom(.headingH3)
            $0.textColor = .black
            $0.textAlignment = .left
        }
        scenarioListTableView.do {
            $0.separatorStyle = .none
            $0.dragInteractionEnabled = true
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            titleLabel,
            addScenarioButton,
            scenarioListTableView
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(48.adjustedH)
        }
        addScenarioButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
        }
        scenarioListTableView.snp.makeConstraints {
            $0.top.equalTo(addScenarioButton.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview()
        }
    }
}

extension ScenarioListView {
    
    func replaceEmptyView() {
        scenarioListTableView.removeFromSuperview()
        addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.top.equalTo(addScenarioButton.snp.bottom).offset(144.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(10.adjustedH)
            $0.height.equalTo(249.adjustedH)
        }
    }
    
    func replaceScenarioView() {
        emptyView.removeFromSuperview()
        addSubview(scenarioListTableView)
        scenarioListTableView.snp.makeConstraints {
            $0.top.equalTo(addScenarioButton.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview()
        }
    }
}
