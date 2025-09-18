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
    private var memberName: String?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            guard let result = try await viewModel.action(
                input: .viewWillAppear
            ) as? ProfileViewModel.MemberNameOutput else { return}
            
            memberName = result.name
            rootView.bind(name: result.name)
        }
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
        guard let memberName = memberName else { return }
        
        let viewController = ViewControllerFactory.shared.makeModifyNicknameViewController()
        viewController.do {
            $0.navigationItem.hidesBackButton = true
            $0.configure(memberName)
        }
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @objc
    private func logoutButtonDidTap() {
        Task {
            let result = try await viewModel.action(input: .logoutButtonDidTap) as! ProfileViewModel.LogoutOutput
            if result.isSucceedLogout {
                let loginViewController = ViewControllerFactory.shared.makeLoginViewController()
                ViewControllerUtil.shared.replaceRootViewController(to: loginViewController)
                return
            }
            BeforeGoingLogger.error(BeforeGoingError.logoutFailed)
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
