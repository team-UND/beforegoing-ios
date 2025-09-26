//
//  SetNoticeMethodViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class SetNoticeMethodViewController: BaseViewController {
    
    private let rootView = SetNoticeMethodView()
    private let viewModel: AddScenarioViewModel
    
    init(viewModel: AddScenarioViewModel) {
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
        Task {
            let noticeMethodType = rootView.selectNoticeMethodView.getSelectedNoticeMethodType()
            do {
                let _ = try await viewModel.action(
                    input: .saveButtonInSetNoticeMethodDidTap(noticeMethodType: noticeMethodType)
                )
                self.navigationController?.popToRootViewController(animated: false)
            } catch {
                BeforeGoingLogger.error(error)
            }
        }
    }
}
