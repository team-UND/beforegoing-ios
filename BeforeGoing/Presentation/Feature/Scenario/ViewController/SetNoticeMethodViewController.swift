//
//  SetNoticeMethodViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class SetNoticeMethodViewController: BaseViewController {
    
    private let rootView = SetNoticeMethodView()
    
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
        self.navigationController?.popToRootViewController(animated: false)
    }
}
