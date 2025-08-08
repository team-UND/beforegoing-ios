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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
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
            let text = nicknameView.nicknameTextField.text else { return }
            
            let trimmedText = trimText(text)
            if trimmedText.isValidNickname {
                nicknameView.enableStartButton()
                return
            }
            nicknameView.disableStartButton()
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
