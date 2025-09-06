//
//  ProfileViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/5/25.
//

import UIKit

final class ProfileViewController: BaseViewController {
    
    private let rootView = ProfileView()
    
    override func loadView() {
        view = rootView
    }
    
    override func setAction() {
        rootView.modifyNameButton.addTarget(
            self,
            action: #selector(modifyNameButtonDidTap),
            for: .touchUpInside
        )
        rootView.logoutView.seeMoreButton.addTarget(
            self,
            action: #selector(logoutButtonDidTap),
            for: .touchUpInside
        )
        rootView.withdrawView.seeMoreButton.addTarget(
            self,
            action: #selector(withdrawButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension ProfileViewController: Backable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension ProfileViewController {
    
    @objc
    private func modifyNameButtonDidTap() {
        let viewController = ModifyNameViewController()
        viewController.navigationItem.hidesBackButton = true
        viewController.configure(rootView.getUserName())
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @objc
    private func logoutButtonDidTap() {
        
    }
    
    @objc
    private func withdrawButtonDidTap() {
        let viewController = ModalViewController(
            modalView: ModalView(type: .withdraw),
            action: nil
        )
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
}
