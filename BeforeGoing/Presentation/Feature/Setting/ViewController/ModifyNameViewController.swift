//
//  ModifyNameViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/5/25.
//

import UIKit

final class ModifyNameViewController: BaseViewController {
    
    private let rootView = ModifyNameView()
    private var initialName: String?
    private let viewModel: ModifyNicknameViewModel
    
    init(viewModel: ModifyNicknameViewModel) {
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
        rootView.nameTextField.addTarget(
            self,
            action: #selector(nameTextFieldDidChange),
            for: .editingChanged
        )
        rootView.confirmButton.addTarget(
            self,
            action: #selector(confirmButtonDidTap),
            for: .touchUpInside
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

extension ModifyNameViewController: Backable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension ModifyNameViewController: NetworkRequestable, NetworkRequestErrorHandler {
    
    @objc
    private func nameTextFieldDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let text = rootView.nameTextField.text else {
                return
            }
            rootView.updateDeleteButtonState(condition: text.isBlank)
            
            let trimmedText = trimText(text)
            rootView.updateNameCount(trimmedText.count)
            rootView.updateConfirmButtonState(condition: trimmedText.isValidNickname)
        }
    }
    
    @objc
    private func confirmButtonDidTap() {
        guard let nickname = rootView.nameTextField.text,
              !nickname.isBlank else {
            return
        }
        guard let initialName = initialName,
              initialName != nickname else {
            self.navigationController?.popViewController(animated: false)
            return
        }
        
        Task {
            let result = try await viewModel.action(input: .confirmButtonDidTap(nickname: nickname))
            switch result.updateNicknameResult {
            case .success:
                self.navigationController?.popViewController(animated: false)
            case .failure(let error):
                self.handleError(error)
                BeforeGoingLogger.error(BeforeGoingError.updateNicknameFailed)
            }
        }
    }
    
    private func trimText(_ text: String) -> String {
        let trimmedText = text.trim(limit: 8)
        if text != trimmedText {
            self.rootView.nameTextField.text = trimmedText
        }
        return trimmedText
    }
}

extension ModifyNameViewController {
    
    func configure(_ name: String) {
        self.initialName = name
        rootView.configureName(name)
    }
}
