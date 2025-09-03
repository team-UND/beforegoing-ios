//
//  AlarmViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

final class AlarmViewController: BaseViewController {
    
    private let rootView = AlarmView()
    
    override func loadView() {
        view = rootView
    }
    
    override func setAction() {
        [rootView.selectAlarmOptionView.noAlarmView, rootView.selectAlarmOptionView.setTimeAlarmView].forEach {
            $0.radioButton.addTarget(self, action: #selector(radioButtonDidTap), for: .touchUpInside)
        }
        rootView.setAlarmTimeView.selectDayView.everydayButton.addTarget(
            self,
            action: #selector(everydayButtonDidTap),
            for: .touchUpInside
        )
        rootView.setAlarmTimeView.selectDayView.dayOfWeekLabels.forEach {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dayOfWeekLabelDidTap(_:)))
            $0.addGestureRecognizer(tapRecognizer)
            $0.isUserInteractionEnabled = true
        }
    }
}

extension AlarmViewController {
    
    @objc
    private func radioButtonDidTap(_ sender: RadioButton) {
        if let alarmOptionView = sender.superview as? AlarmOptionView {
            sender.updateState()
            alarmOptionView.updateUI(isSelected: sender.matchState())
            //To-Do : 하나 눌리면 하나는 해제되기 만들기
        }
    }
    
    @objc
    private func dayOfWeekLabelDidTap(_ tapRecognizer: UITapGestureRecognizer) {
        guard let label = tapRecognizer.view as? UILabel,
              let dayText = label.text else { return }
        
        rootView.setAlarmTimeView.selectDayView.do {
            $0.updateDayOfWeekState(dayText: dayText)
            $0.checkAllSelected()
        }
    }
    
    @objc
    private func everydayButtonDidTap() {
        let state = rootView.setAlarmTimeView.selectDayView.everydayButton.toggle()
        let condition = state.matchState()
        rootView.setAlarmTimeView.selectDayView.updateAllDay(condition: condition)
    }
}
