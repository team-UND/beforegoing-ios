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
        }
    }
}

extension SetNoticeMethodViewController: Backable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension SetNoticeMethodViewController {
    
    @objc
    private func radioButtonDidTap(_ sender: UIButton) {
        guard let methodView = sender.superview as? NoticeMethodView else { return }
        
        rootView.selectNoticeMethodView.toggleMethod(selectedView: methodView)
    }
}
