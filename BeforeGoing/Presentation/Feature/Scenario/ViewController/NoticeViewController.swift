//
//  AlarmViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

final class NoticeViewController: BaseViewController {
    
    private let rootView = NoticeView()
    private let viewModel: ScenarioViewModel
    
    init(viewModel: ScenarioViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func setAction() {
        setGesture()
        
        [rootView.selectNoticeOptionView.noAlarmView, rootView.selectNoticeOptionView.setTimeAlarmView].forEach {
            $0.radioButton.addTarget(self, action: #selector(radioButtonDidTap), for: .touchUpInside)
        }
        rootView.setNoticeTimeView.selectDayView.everydayButton.addTarget(
            self,
            action: #selector(everydayButtonDidTap),
            for: .touchUpInside
        )
        rootView.setNoticeTimeView.selectDayView.dayOfWeekLabels.forEach {
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
    
    private func setGesture() {
        [rootView.selectNoticeOptionView.noAlarmView, rootView.selectNoticeOptionView.setTimeAlarmView].forEach {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(alarmViewDidTap))
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGesture)
        }
    }
}

extension NoticeViewController: Backable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension NoticeViewController {
    
    @objc
    private func alarmViewDidTap(_ gesture: UITapGestureRecognizer) {
        guard let optionView = gesture.view as? NoticeOptionView else { return }

        let radioButton = optionView.radioButton
        radioButtonDidTap(radioButton)
    }
    
    @objc
    private func radioButtonDidTap(_ sender: RadioButton) {
        guard let optionView = sender.superview as? NoticeOptionView else { return }
        
        sender.updateState()
        optionView.updateUI(isSelected: sender.matchState())
        rootView.selectNoticeOptionView.toggleOption(selectedView: optionView)
        
        let isSelectedSetAlarmOption = rootView.selectNoticeOptionView.isSelectedSetAlarmOption(optionView)
        rootView.setNoticeTimeView.updateHiddenState(isSelectedUseTime: isSelectedSetAlarmOption)
        rootView.updateButtonState(isNeededChange: isSelectedSetAlarmOption)
        if isSelectedSetAlarmOption {
            rootView.updateNextButtonState()
        }
    }
    
    @objc
    private func dayOfWeekLabelDidTap(_ tapRecognizer: UITapGestureRecognizer) {
        guard let label = tapRecognizer.view as? UILabel,
              let dayText = label.text else { return }
        
        rootView.setNoticeTimeView.selectDayView.do {
            $0.updateDayOfWeekState(dayText: dayText)
            $0.checkAllSelected()
        }
        rootView.updateNextButtonState()
    }
    
    @objc
    private func everydayButtonDidTap() {
        let state = rootView.setNoticeTimeView.selectDayView.everydayButton.toggle()
        let condition = state.matchState()
        rootView.setNoticeTimeView.selectDayView.updateAllDay(condition: condition)
        rootView.updateNextButtonState()
    }
    
    @objc
    private func saveNextButtonDidTap(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        
        switch text {
        case "저장하기":
            Task {
                let _ = try await viewModel.action(input: .saveButtonInSetNoticeDidTap)
                self.navigationController?.popToRootViewController(animated: false)
            }
        case "다음":
            let daysOfWeek = rootView.setNoticeTimeView.selectDayView.selected
            let startHour = rootView.setNoticeTimeView.timePickerView.getHour()
            let startMinute = rootView.setNoticeTimeView.timePickerView.getMinute()
            
            Task {
                let _ = try await viewModel.action(
                    input: .nextButtonInSetNoticeDidTap(
                        daysOfWeek: daysOfWeek,
                        startHour: startHour,
                        startMinute: startMinute
                    )
                )
                let viewController = ViewControllerFactory.shared.makeSetNoticeMethodViewController()
                viewController.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(viewController, animated: false)
            }
        default:
            break
        }
    }
}
