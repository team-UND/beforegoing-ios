//
//  AlarmView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

enum NoticeBottomButtonTitle: String {
    case save = "저장하기"
    case next = "다음"
}

final class NoticeView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let navigationView = TopNavigationView(title: "알림 설정")
    private(set) var selectNoticeOptionView = SelectNoticeOptionView()
    private(set) var setNoticeTimeView = SetNoticeTimeView()
    private(set) var saveNextButton = CustomButton(
        state: .enableLongButton,
        title: NoticeBottomButtonTitle.save.rawValue
    )
    
    override func setStyle() {
        backgroundImageView.image = .bgTop
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            navigationView,
            selectNoticeOptionView,
            setNoticeTimeView,
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
        selectNoticeOptionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(40.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
        }
        setNoticeTimeView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(220.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        saveNextButton.snp.makeConstraints {
            $0.top.equalTo(setNoticeTimeView.snp.bottom).offset(28.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(34.adjustedH)
        }
    }
}

extension NoticeView {
    
    func updateButtonState(isNeededChange: Bool) {
        isNeededChange ? saveNextButton.updateTitle(NoticeBottomButtonTitle.next.rawValue) : saveNextButton.updateTitle(NoticeBottomButtonTitle.save.rawValue)
        if !isNeededChange {
            saveNextButton.currentState = .enableLongButton
        }
    }
    
    func updateNextButtonState() {
        let isCheckedDay = setNoticeTimeView.selectDayView.isCheckedDay
        saveNextButton.reverseState(isEnabled: isCheckedDay)
    }
}
