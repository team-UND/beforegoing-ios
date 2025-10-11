//
//  SetNoticeMethodViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class SetNoticeMethodViewController: BaseViewController, NetworkRequestable {
    
    private let rootView = SetNoticeMethodView()
    
    private var enterType: SettingScenarioEnterType?
    private var notificationMethod: NoticeMethodType?
    
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
        
        guard let enterType = enterType,
              let notificationMethod = notificationMethod else {
            return
        }
        if !enterType.isAddScenarioType {
            notificationMethod.isPush ?
            radioButtonDidTap(rootView.selectNoticeMethodView.pushNoticeView.radioButton) :
            radioButtonDidTap(rootView.selectNoticeMethodView.alarmView.radioButton)
        }
    }
    
    override func setAction() {
        [rootView.selectNoticeMethodView.pushNoticeView, rootView.selectNoticeMethodView.alarmView].forEach {
            $0.radioButton.addTarget(self, action: #selector(radioButtonDidTap), for: .touchUpInside)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap))
            $0.imageView.addGestureRecognizer(tapGesture)
            $0.imageView.isUserInteractionEnabled = true
        }
        rootView.saveButton.addTarget(
            self,
            action: #selector(saveButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension SetNoticeMethodViewController: Backable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension SetNoticeMethodViewController {
    
    func configure(
        enterType: SettingScenarioEnterType,
        notificationMethod: NoticeMethodType?
    ) {
        self.enterType = enterType
        self.notificationMethod = notificationMethod
    }
}

extension SetNoticeMethodViewController {
    
    @objc
    private func imageViewDidTap(_ sender: UITapGestureRecognizer) {
        guard
            let imageView = sender.view as? UIImageView,
            let methodView = imageView.superview as? NoticeMethodView
        else { return }
        
        rootView.selectNoticeMethodView.toggleMethod(selectedView: methodView)
    }
    
    @objc
    private func radioButtonDidTap(_ sender: UIButton) {
        guard let methodView = sender.superview as? NoticeMethodView else { return }
        
        rootView.selectNoticeMethodView.toggleMethod(selectedView: methodView)
    }
    
    @objc
    private func saveButtonDidTap() {
        guard let enterType = enterType else { return }
        enterType.isAddScenarioType ? addScenario() : updateScenario()
    }
    
    private func addScenario() {
        Task {
            let noticeMethodType = rootView.selectNoticeMethodView.getSelectedNoticeMethodType()
            do {
                let _ = try await addScenarioViewModel.action(
                    input: .saveButtonInSetNoticeMethodDidTap(noticeMethodType: noticeMethodType)
                )
                self.navigationController?.popToRootViewController(animated: false)
            } catch {
                if let error = error as? BeforeGoingError,
                   error == .loginExpired {
                    self.presentLoginExpired()
                }
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    private func updateScenario() {
        Task {
            let noticeMethodType = rootView.selectNoticeMethodView.getSelectedNoticeMethodType()
            do {
                let _ = try await updateScenarioViewModel.action(
                    input: .saveButtonInSetNoticeMethodDidTap(noticeMethodType: noticeMethodType)
                )
                self.navigationController?.popToRootViewController(animated: false)
            } catch {
                if let error = error as? BeforeGoingError,
                   error == .loginExpired {
                    self.presentLoginExpired()
                }
                BeforeGoingLogger.error(error)
            }
        }
    }
}
