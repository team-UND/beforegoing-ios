//
//  AlarmView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

final class AlarmView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let navigationView = TopNavigationView(title: "알림 설정")
    private(set) var selectAlarmOptionView = SelectAlarmOptionView()
    private(set) var setAlarmTimeView = SetAlarmTimeView()
    private(set) var saveNextButton = CustomButton(state: .enableLongButton, title: "저장하기")
    
    override func setStyle() {
        backgroundImageView.image = .bgTop
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            navigationView,
            selectAlarmOptionView,
            setAlarmTimeView,
            saveNextButton
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48.adjustedH)
        }
        selectAlarmOptionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(40.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
        }
        setAlarmTimeView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(220.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        saveNextButton.snp.makeConstraints {
            $0.top.equalTo(setAlarmTimeView.snp.bottom).offset(28.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(34.adjustedH)
        }
    }
}

extension AlarmView {
    
    func updateButtonState(isNeededChange: Bool) {
        isNeededChange ? saveNextButton.updateTitle("다음") : saveNextButton.updateTitle("저장하기")
    }
}
