//
//  NicknameViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/6/25.
//

import UIKit

final class NicknameViewController: BaseViewController {
    
    private let nicknameView = NicknameView()
    private static let maxNumberOfCharacters = 8
    private let viewModel: NicknameViewModel
    
    init(viewModel: NicknameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override func setView() {
        TopNavigationBar.makeNavigationBar(
            navigationController: self.navigationController,
            type: .clear
        )
        view.addSubview(nicknameView)
        nicknameView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setAction() {
        nicknameView.nicknameTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        nicknameView.deleteButton.addTarget(
            self,
            action: #selector(deleteButtonDidTap),
            for: .touchUpInside
        )
        nicknameView.startButton.addTarget(
            self,
            action: #selector(startButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension NicknameViewController: Backable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension NicknameViewController {
    
    @objc
    private func textFieldDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let text = nicknameView.nicknameTextField.text else {
                return
            }
            text.isEmpty ? nicknameView.hideDeleteButton() : nicknameView.revealDeleteButton()
            
            let trimmedText = trimText(text)
            if trimmedText.isValidNickname {
                nicknameView.enableStartButton()
                return
            }
            nicknameView.disableStartButton()
        }
    }
    
    @objc
    private func deleteButtonDidTap() {
        nicknameView.nicknameTextField.text = ""
        textFieldDidChange()
    }
    
    @objc
    private func startButtonDidTap() {
        guard let nickname = nicknameView.nicknameTextField.text,
              !nickname.isEmpty else {
            return
        }
        
        Task {
            let result = try await viewModel.action(input: .startButtonDidTap(nickname: nickname))
            
            switch result {
            case .updateNicknameResult(let isNicknameUpdated):
                if isNicknameUpdated {
                    let viewController = ViewControllerFactory.shared.makeOnboardingViewController()
                    viewController.navigationItem.hidesBackButton = true
                    self.navigationController?.pushViewController(viewController, animated: false)
                    return
                }
                BeforeGoingLogger.error(BeforeGoingError.updateNicknameFailed)
            }
        }
    }
    
    private func trimText(_ text: String) -> String {
        let trimmedText = text.trim(limit: NicknameViewController.maxNumberOfCharacters)
        if text != trimmedText {
            self.nicknameView.nicknameTextField.text = trimmedText
        }
        return trimmedText
    }
}
