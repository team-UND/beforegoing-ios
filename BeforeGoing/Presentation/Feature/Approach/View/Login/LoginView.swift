//
//  LoginView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import SnapKit

import UIKit

final class LoginView: BaseView {
    
    private let backgrounImageView = UIImageView()
    private let appIconImageView = UIImageView()
    private let subtitleLabel = UILabel()
    private let mainTitleLabel = UILabel()
    private(set) var kakaoLoginButton = UIButton()
    private(set) var appleLoginButton = UIButton()
    private var buttonConfiguration = UIButton.Configuration.plain()
    
    private var iconTopConstraint: Constraint?
    
    override func setStyle() {
        backgrounImageView.do {
            $0.image = .bgSplash
        }
        appIconImageView.do {
            $0.image = .character
            $0.contentMode = .scaleAspectFit
        }
        subtitleLabel.do {
            $0.text = ApproachLiteral.subtitle.rawValue
            $0.textColor = .gray900
            $0.textAlignment = .center
            $0.font = .custom(.brandingMedium)
        }
        mainTitleLabel.do {
            $0.makeStrokeTextAttributes()
            $0.textAlignment = .center
        }
        buttonConfiguration.background.backgroundColor = .clear
        kakaoLoginButton.do {
            $0.setImage(.kakaoLogin, for: .normal)
            $0.configuration = buttonConfiguration
            $0.alpha = 0
        }
        appleLoginButton.do {
            $0.setImage(.appleLogin, for: .normal)
            $0.configuration = buttonConfiguration
            $0.alpha = 0
        }
    }
    
    override func setUI() {
        addSubviews(
            backgrounImageView,
            appIconImageView,
            subtitleLabel,
            mainTitleLabel,
            kakaoLoginButton,
            appleLoginButton
        )
    }
    
    override func setLayout() {
        backgrounImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        appIconImageView.snp.makeConstraints {
            self.iconTopConstraint = $0.top.equalToSuperview().inset(311.adjustedH).constraint
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180.adjustedW)
            $0.height.equalTo(150.adjustedH)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(appIconImageView.snp.bottom).offset(20.adjustedH)
            $0.centerX.equalToSuperview()
        }
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(6.adjustedH)
            $0.centerX.equalToSuperview()
        }
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(151.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(54.adjustedH)
        }
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(12.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(120.adjustedH)
            $0.height.equalTo(54.adjustedH)
        }
    }
}

extension LoginView {
    
    func startAnimating() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut]) {
                self.iconTopConstraint?.update(inset: 200.adjustedH)
                self.appleLoginButton.alpha = 1
                self.kakaoLoginButton.alpha = 1
                self.layoutIfNeeded()
            }
        }
    }
}
