//
//  ManageScenarioView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/26/25.
//

import UIKit

final class ManageScenarioView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let topNavigationView = TopNavigationView(title: "나에게 딱 맞는\n시나리오 템플릿을 선택해요")
    private(set) var templateTableView = UITableView()
    private(set) var selectButton = CustomButton(state: .disableLongButton, title: "템플릿 선택하기")
        
    override func setStyle() {
        backgroundImageView.image = .bgTop
        templateTableView.separatorStyle = .none
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            topNavigationView,
            templateTableView,
            selectButton
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        topNavigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(82.adjustedH)
        }
        templateTableView.snp.makeConstraints {
            $0.top.equalTo(topNavigationView.snp.bottom).offset(36.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalTo(selectButton.snp.top).offset(-33.adjustedH)
        }
        selectButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(34.adjustedH)
        }
    }
}

extension ManageScenarioView {
    
    func updateStyle() {
        selectButton.currentState = .enableLongButton
    }
}
