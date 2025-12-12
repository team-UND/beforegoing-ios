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
        setGesture()
        
        rootView.modifyNameButton.addTarget(
            self,
            action: #selector(modifyNameButtonDidTap),
            for: .touchUpInside
        )
        rootView.logoutView.seeMoreButton.addTarget(
            self,
            action: #selector(logoutDidTap),
            for: .touchUpInside
        )
        rootView.withdrawView.seeMoreButton.addTarget(
            self,
            action: #selector(withdrawDidTap),
            for: .touchUpInside
        )
    }
    
    private func setGesture() {
        let logoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutDidTap))
        rootView.logoutView.do {
            $0.addGestureRecognizer(logoutTapGesture)
            $0.isUserInteractionEnabled = true
        }
        
        let withdrawTapGesture = UITapGestureRecognizer(target: self, action: #selector(withdrawDidTap))
        rootView.withdrawView.do {
            $0.addGestureRecognizer(withdrawTapGesture)
            $0.isUserInteractionEnabled = true
        }
    }
}

extension ProfileViewController: Backable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension ProfileViewController: NetworkRequestable, NetworkRequestErrorHandler {
    
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
    private func logoutDidTap() {
        presentModal(modalType: .logout)
    }
    
    @objc
    private func withdrawDidTap() {
        presentModal(modalType: .withdraw)
    }
    
    private func presentModal(modalType: ModalType) {
        var action: () -> Void
        
        switch modalType {
        case .logout:
            action = defineLogout()
        case .withdraw:
            action = defineWithdrawal()
        default:
            action = {}
        }
        
        let viewController = ModalViewController(
            modalView: ModalView(type: modalType),
            action: action
        )
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
    
    private func defineLogout() -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            Task {
                do {
                    guard let result = try await self.viewModel.action(
                        input: .logoutButtonDidTap
                    ) as? ProfileViewModel.LogoutOutput else {
                        return
                    }
                    if result.isSucceedLogout {
                        let loginViewController = ViewControllerFactory.shared.makeLoginViewController()
                        let navigationController = UINavigationController(rootViewController: loginViewController)
                        ViewControllerUtil.replaceRootViewController(to: navigationController)
                        return
                    }
                } catch {
                    self.handleError(error)
                    BeforeGoingLogger.error(BeforeGoingError.logoutFailed)
                }
            }
        }
    }
    
    private func defineWithdrawal() -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            Task {
                do {
                    guard let result = try await self.viewModel.action(
                        input: .withdrawButtonDidTap
                    ) as? ProfileViewModel.WithdrawOutput else {
                        return
                    }
                    if result.isSucceedWithdraw {
                        self.dismiss(animated: false)
                        
                        let viewController = ViewControllerFactory.shared.makeLoginViewController()
                        let navigationController = UINavigationController(rootViewController: viewController)
                        ViewControllerUtil.replaceRootViewController(to: navigationController)
                    }
                } catch {
                    self.handleError(error)
                }
            }
        }
    }
}
