//
//  ModifyNameViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/5/25.
//

import UIKit

final class ModifyNameViewController: BaseViewController {
    
    private let rootView = ModifyNameView()
    
    override func loadView() {
        view = rootView
    }
    
    override func setAction() {
        rootView.nameTextField.addTarget(
            self,
            action: #selector(nameTextFieldDidChange),
            for: .editingChanged
        )
    }
}

extension ModifyNameViewController: Backable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension ModifyNameViewController {
    
    @objc
    private func nameTextFieldDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let text = rootView.nameTextField.text else {
                return
            }
            rootView.updateDeleteButtonState(condition: text.isEmpty)
            
            let trimmedText = trimText(text)
            rootView.updateNameCount(trimmedText.count)
            rootView.updateConfirmButtonState(condition: trimmedText.isValidNickname)
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
        rootView.configureName(name)
    }
}
