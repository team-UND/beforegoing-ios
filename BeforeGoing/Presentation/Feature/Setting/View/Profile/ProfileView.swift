//
//  ProfileView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/5/25.
//

import UIKit

final class ProfileView: BaseView {
    
    private let navigationView = TopNavigationView(title: "프로필")
    private let worryImageView = UIImageView()
    private let nameLabel = UILabel()
    private(set) var modifyNameButton = UIButton()
    private let divider = UILabel()
    private(set) var logoutView = ProfileFeatureView(title: "로그아웃")
    private(set) var withdrawView = ProfileFeatureView(title: "회원탈퇴")
    
    override func setStyle() {
        worryImageView.do {
            $0.image = .profile
        }
        nameLabel.do {
            $0.text = "허승준"    // 추후 변경
            $0.textColor = .gray900
            $0.font = .custom(.headingH4)
        }
        modifyNameButton.do {
            $0.setImage(.edit, for: .normal)
        }
        divider.do {
            $0.backgroundColor = .gray50
        }
    }
    
    override func setUI() {
        addSubviews(
            navigationView,
            worryImageView,
            nameLabel,
            modifyNameButton,
            divider,
            logoutView,
            withdrawView
        )
    }
    
    override func setLayout() {
        navigationView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48.adjustedH)
        }
        worryImageView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(40.adjustedH)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(180.adjustedW)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(worryImageView.snp.bottom).offset(12.adjustedH)
            $0.centerX.equalTo(worryImageView.snp.centerX)
            $0.height.equalTo(26.adjustedH)
        }
        modifyNameButton.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing)
            $0.centerY.equalTo(nameLabel.snp.centerY)
            $0.size.equalTo(16.adjustedW)
        }
        divider.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(40.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(6.adjustedH)
        }
        logoutView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(32.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48.adjustedH)
        }
        withdrawView.snp.makeConstraints {
            $0.top.equalTo(logoutView.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48.adjustedH)
            $0.bottom.equalToSuperview().inset(220.adjustedH)
        }
    }
}

extension ProfileView {
    
    func getUserName() -> String {
        nameLabel.text ?? ""
    }
}
