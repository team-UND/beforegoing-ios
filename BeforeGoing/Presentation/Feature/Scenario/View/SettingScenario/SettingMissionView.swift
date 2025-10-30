//
//  SettingMissionView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/1/25.
//

import UIKit

final class SettingMissionView: BaseView {
    
    private let maxLength = 20
    
    private let missionTitleLabel = UILabel()
    private(set) var missionTextField = TextField(type: .enableAddField)
    private(set) var addMissionButton = UIButton()
    private(set) var deleteMissionButton = UIButton()
    private(set) var missionTableView = UITableView()
        
    override func setStyle() {
        missionTitleLabel.do {
            $0.text = "미션 설정"
            $0.textColor = .gray600
            $0.font = .custom(.bodyLGMedium)
        }
        missionTextField.do {
            $0.placeholder = "항목을 추가하세요"
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: missionTextField.frame.height))
            $0.leftViewMode = .always
        }
        addMissionButton.do {
            $0.setImage(.plusCircle.withTintColor(.gray400), for: .normal)
        }
        deleteMissionButton.do {
            $0.setImage(.union, for: .normal)
            $0.isHidden = true
        }
        missionTableView.separatorStyle = .none
    }
    
    override func setUI() {
        addSubviews(
            missionTitleLabel,
            missionTextField,
            addMissionButton,
            deleteMissionButton,
            missionTableView
        )
    }
    
    override func setLayout() {
        missionTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        missionTextField.snp.makeConstraints {
            $0.top.equalTo(missionTitleLabel.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        addMissionButton.snp.makeConstraints {
            $0.trailing.equalTo(missionTextField.snp.trailing).offset(-20.adjustedW)
            $0.centerY.equalTo(missionTextField.snp.centerY)
            $0.size.equalTo(24.adjustedW)
        }
        deleteMissionButton.snp.makeConstraints {
            $0.trailing.equalTo(addMissionButton.snp.leading)
            $0.centerY.equalTo(missionTextField.snp.centerY)
            $0.size.equalTo(24.adjustedW)
        }
        missionTableView.snp.makeConstraints {
            $0.top.equalTo(missionTextField.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(236.adjustedH)
            $0.bottom.equalToSuperview().inset(29.adjustedH)
        }
    }
}

extension SettingMissionView {
    
    private func hideDeleteButton() {
        deleteMissionButton.isHidden = true
    }
    
    func revealDeleteButton() {
        deleteMissionButton.isHidden = false
    }
    
    func deleteAllText() {
        missionTextField.text = ""
        hideDeleteButton()
    }
    
    func getUserMission() -> String? {
        guard let text = missionTextField.text else { return nil }
        return text.removeTrailingSpaces()
    }
    
    func updateText() {
        guard let text = missionTextField.text else { return }
        missionTextField.text = text
            .trim(limit: maxLength)
            .removeLeadingSpaces()
    }
}
