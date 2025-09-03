//
//  SettingScenarioView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/1/25.
//

import UIKit

final class SettingScenarioView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let topNavigationView = TopNavigationView(title: "시나리오 설정")
    private(set) var inputScenarioView = InputInformationView(title: "시나리오명", maxLength: 10)
    private(set) var inputMemoView = InputInformationView(title: "메모", maxLength: 15)
    private(set) var settingMissionView = SettingMissionView()
    private(set) var nextButton = CustomButton(state: .disableLongButton, title: "다음")
    
    override func setStyle() {
        backgroundImageView.image = .bgTop
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            topNavigationView,
            inputScenarioView,
            inputMemoView,
            settingMissionView,
            nextButton
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        topNavigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48.adjustedH)
        }
        inputScenarioView.snp.makeConstraints {
            $0.top.equalTo(topNavigationView.snp.bottom).offset(40.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
        }
        inputMemoView.snp.makeConstraints {
            $0.top.equalTo(inputScenarioView.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
        }
        settingMissionView.snp.makeConstraints {
            $0.top.equalTo(inputMemoView.snp.bottom).offset(40.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
        }
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(34.adjustedH)
        }
    }
}

extension SettingScenarioView {
    
    func updateUI(state: ButtonState) {
        nextButton.currentState = state
    }
}
