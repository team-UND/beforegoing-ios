//
//  ModalViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/5/25.
//

import UIKit

final class ModalViewController: BaseViewController {
    
    private let modalView: ModalView
    private let action: (() -> Void)?
    
    init(modalView: ModalView, action: (() -> Void)? = nil) {
        self.modalView = modalView
        self.action = action
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setView() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubviews(blurView, modalView)
        
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        modalView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(45.adjustedW)
            $0.centerY.equalToSuperview()
        }
    }
    
    override func setAction() {
        modalView.dismissButton.addTarget(
            self,
            action: #selector(dismissButtonDidTap),
            for: .touchUpInside
        )
        modalView.actionButton.addTarget(
            self,
            action: #selector(actionButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension ModalViewController {
    
    @objc
    private func dismissButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func actionButtonDidTap() {
        self.action?()
    }
}
