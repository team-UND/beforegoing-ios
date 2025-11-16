//
//  ToastPresentable.swift
//  BeforeGoing
//
//  Created by APPLE on 11/2/25.
//

import UIKit

protocol ToastPresentable: AnyObject {
    func presentToastMessage(type: ToastMessageType)
}

extension ToastPresentable where Self: BaseViewController {
    
    func presentToastMessage(type: ToastMessageType) {
        let toastMessageView = ToastMessageView(text: type.message)
        
        setUI(toastMessageView)
        setLayout(toastMessageView)
        
        HapticManager.shared.notice(feedbackType: .error)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.removeUI(toastMessageView)
        }
    }
    
    private func setUI(_ view: ToastMessageView) {
        self.view.addSubview(view)
    }
    
    private func setLayout(_ view: ToastMessageView) {
        view.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(110.adjustedH)
        }
    }
    
    private func removeUI(_ view: ToastMessageView) {
        view.do {
            $0.removeFromSuperview()
            $0.snp.removeConstraints()
        }
    }
}
