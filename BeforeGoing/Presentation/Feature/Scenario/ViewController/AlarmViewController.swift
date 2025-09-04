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
        rootView.saveNextButton.addTarget(
            self,
            action: #selector(saveNextButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension AlarmViewController {
    
    @objc
    private func radioButtonDidTap(_ sender: RadioButton) {
        guard let optionView = sender.superview as? AlarmOptionView else { return }
        
        sender.updateState()
        optionView.updateUI(isSelected: sender.matchState())
        rootView.selectAlarmOptionView.toggleOption(selectedView: optionView)
        
        let isSelectedSetAlarmOption = rootView.selectAlarmOptionView.isSelectedSetAlarmOption(optionView)
        rootView.setAlarmTimeView.updateHiddenState(isSelectedUseTime: isSelectedSetAlarmOption)
        rootView.updateButtonState(isNeededChange: isSelectedSetAlarmOption)
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
    
    @objc
    private func saveNextButtonDidTap(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        
        switch text {
        case "저장하기":
            self.navigationController?.popToRootViewController(animated: false)
        case "다음":
            let viewController = SetNoticeMethodViewController()
            viewController.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(viewController, animated: false)
        default:
            break
        }
    }
}
