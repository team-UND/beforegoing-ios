//
//  SelectAlarmOptionView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

final class SelectNoticeOptionView: BaseView {
    
    private let optionStackView = UIStackView()
    private(set) var noAlarmView = NoticeOptionView(type: .noNotice)
    private(set) var setTimeAlarmView = NoticeOptionView(type: .setTimeNotice)
    
    override func setStyle() {
        optionStackView.do {
            $0.axis = .vertical
            $0.spacing = 12
        }
    }
    
    override func setUI() {
        addSubview(optionStackView)
        optionStackView.addArrangedSubviews(
            noAlarmView,
            setTimeAlarmView
        )
    }
    
    override func setLayout() {
        optionStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(120.adjustedH)
        }
        noAlarmView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        setTimeAlarmView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

extension SelectNoticeOptionView {
    
    func toggleOption(selectedView: NoticeOptionView) {
        optionStackView.arrangedSubviews.forEach {
            guard let optionView = $0 as? NoticeOptionView else { return }
            if !optionView.equalTo(selectedView) {
                optionView.updateUI(isSelected: false)
            }
        }
    }
    
    func isSelectedSetAlarmOption(_ optionView: NoticeOptionView) -> Bool {
        optionView == setTimeAlarmView
    }
}
