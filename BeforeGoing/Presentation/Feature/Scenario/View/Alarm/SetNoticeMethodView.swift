//
//  SelectAlarmMethodView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class SetNoticeMethodView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let navigationView = TopNavigationView(title: "알림 설정")
    private let questionLabel = UILabel()
    private(set) var selectNoticeMethodView = SelectNoticeMethodView()
    private let saveButton = CustomButton(state: .enableLongButton, title: "저장하기")
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgTop
        }
        questionLabel.do {
            $0.text = "어떻게 알려드릴까요?"
            $0.textColor = .gray900
            $0.font = .custom(.headingH5)
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            navigationView,
            questionLabel,
            selectNoticeMethodView,
            saveButton
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
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(40.adjustedH)
            $0.leading.equalToSuperview().inset(20.adjustedW)
        }
        selectNoticeMethodView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(105.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
        }
        saveButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(34.adjustedH)
        }
    }
}
