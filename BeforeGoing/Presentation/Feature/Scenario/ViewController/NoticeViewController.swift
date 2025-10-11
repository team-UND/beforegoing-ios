//
//  AlarmViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

final class NoticeViewController: BaseViewController, NetworkRequestable {
    
    private let rootView = NoticeView()
    
    private var isNotificationActive: Bool?
    private var daysOfWeek: [Int]?
    private var startHour: Int?
    private var startMinute: Int?
    private var notificationMethod: NoticeMethodType?
    private var enterType: SettingScenarioEnterType?
    
    private let addScenarioViewModel: AddScenarioViewModel
    private let updateScenarioViewModel: UpdateScenarioViewModel
    
    init(
        addScenarioViewModel: AddScenarioViewModel,
        updateScenarioViewModel: UpdateScenarioViewModel
    ) {
        self.addScenarioViewModel = addScenarioViewModel
        self.updateScenarioViewModel = updateScenarioViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let isNotificationActive = isNotificationActive,
              let enterType = enterType else {
            return
        }
        if !enterType.isAddScenarioType && isNotificationActive {
            guard let daysOfWeek = daysOfWeek,
                  let startHour = startHour,
                  let startMinute = startMinute else {
                return
            }
            let setTimeAlarmRadioButton = rootView.selectNoticeOptionView.setTimeAlarmView.radioButton
            radioButtonDidTap(setTimeAlarmRadioButton)
            rootView.do {
                $0.setNoticeTimeView.selectDayView.updateDayOfWeekState(daysOfWeek: daysOfWeek)
                $0.updateNextButtonState()
                $0.setNoticeTimeView.timePickerView.updateTime(
                    startHour: startHour,
                    startMinute: startMinute
                )
            }
        }
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
        guard let text = sender.titleLabel?.text,
              let enterType = enterType else {
            return
        }
        
        switch text {
        case "저장하기":
            Task {
                if enterType.isAddScenarioType {
                    do {
                        let _ = try await addScenarioViewModel.action(input: .saveButtonInSetNoticeDidTap)
                    } catch {
                        if let error = error as? BeforeGoingError,
                           error == .loginExpired {
                            self.presentLoginExpired()
                        }
                    }
                } else {
                    do {
                        let _ = try await updateScenarioViewModel.action(input: .saveButtonInSetNoticeDidTap)
                    } catch {
                        if let error = error as? BeforeGoingError,
                           error == .loginExpired {
                            self.presentLoginExpired()
                        }
                    }
                }
                self.navigationController?.popToRootViewController(animated: false)
            }
        case "다음":
            let daysOfWeek = rootView.setNoticeTimeView.selectDayView.selected
            let startHour = rootView.setNoticeTimeView.timePickerView.getHour()
            let startMinute = rootView.setNoticeTimeView.timePickerView.getMinute()
            
            enterType.isAddScenarioType ? saveNoticeInformationForAddScenario(
                daysOfWeek: daysOfWeek,
                startHour: startHour,
                startMinute: startMinute
            ) : saveNoticeInformationForUpdateScenario(
                daysOfWeek: daysOfWeek,
                startHour: startHour,
                startMinute: startMinute
            )
        default:
            break
        }
    }
    
    private func saveNoticeInformationForAddScenario(
        daysOfWeek: [Int],
        startHour: Int?,
        startMinute: Int?
    ) {
        Task {
            do {
                let _ = try await addScenarioViewModel.action(
                    input: .nextButtonInSetNoticeDidTap(
                        daysOfWeek: daysOfWeek,
                        startHour: startHour,
                        startMinute: startMinute
                    )
                )
                moveSetNoticeMethod(
                    enterType: .addScenario,
                    notificationMethod: notificationMethod
                )
            } catch {
                if let error = error as? BeforeGoingError,
                   error == .loginExpired {
                    self.presentLoginExpired()
                }
            }
        }
    }
    
    private func saveNoticeInformationForUpdateScenario(
        daysOfWeek: [Int],
        startHour: Int?,
        startMinute: Int?
    ) {
        Task {
            do {
                let _ = try await updateScenarioViewModel.action(
                    input: .nextButtonInSetNoticeDidTap(
                        daysOfWeek: daysOfWeek,
                        startHour: startHour,
                        startMinute: startMinute
                    )
                )
                moveSetNoticeMethod(
                    enterType: .updateScenario,
                    notificationMethod: notificationMethod
                )
            } catch {
                if let error = error as? BeforeGoingError,
                   error == .loginExpired {
                    self.presentLoginExpired()
                }
            }
        }
    }
    
    private func moveSetNoticeMethod(
        enterType: SettingScenarioEnterType,
        notificationMethod: NoticeMethodType?
    ) {
        let viewController = ViewControllerFactory.shared.makeSetNoticeMethodViewController()
        viewController.navigationItem.hidesBackButton = true
        viewController.configure(
            enterType: enterType,
            notificationMethod: notificationMethod
        )
        self.navigationController?.pushViewController(viewController, animated: false)
    }
}

extension NoticeViewController {
    
    func configure(
        isNotificationActive: Bool?,
        daysOfWeek: [Int]?,
        startHour: Int?,
        startMinute: Int?,
        notificationMethod: NoticeMethodType?,
        enterType: SettingScenarioEnterType
    ) {
        self.isNotificationActive = isNotificationActive
        self.daysOfWeek = daysOfWeek
        self.startHour = startHour
        self.startMinute = startMinute
        self.notificationMethod = notificationMethod
        self.enterType = enterType
    }
}
