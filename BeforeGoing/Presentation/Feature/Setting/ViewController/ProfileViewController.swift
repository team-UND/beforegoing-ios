//
//  ProfileViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/5/25.
//

import UIKit

final class ProfileViewController: BaseViewController {
    
    private let rootView = ProfileView()
    private let viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
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
        Task {
            do {
                try await viewModel.action(input: .logoutButtonDidTap)
                let loginViewController = ViewControllerFactory.shared.makeLoginViewController()
                ViewControllerUtil.shared.replaceRootViewController(to: loginViewController)
            } catch {
                BeforeGoingLogger.error(BeforeGoingError.logoutFailed)
            }
        }
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
