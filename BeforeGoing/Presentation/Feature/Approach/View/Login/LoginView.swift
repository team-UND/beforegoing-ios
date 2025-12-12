//
//  LoginView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import SnapKit

import Lottie
import UIKit

final class LoginView: BaseView {
    
    private let backgrounImageView = UIImageView()
    private let appIconImageView = LottieAnimationView(name: "splashMotion")
    private let subtitleLabel = UILabel()
    private(set) var mainTitleLabel = UILabel()
    private(set) var kakaoLoginButton = UIButton()
    private(set) var appleLoginButton = UIButton()
    private(set) var lastLoginBadgeView = LastLoginBadgeView()
    
    private(set) var appIconTopConstraint: Constraint?
    private(set) var kakaoLoginTopConstraint: Constraint?
    private var lastLoginBadgeBottomConstraint: Constraint?
        
    override func setStyle() {
        backgrounImageView.do {
            $0.image = .bgSplash
        }
        appIconImageView.do {
            $0.loopMode = .loop
            $0.backgroundBehavior = .pauseAndRestore
            $0.play()
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
        kakaoLoginButton.do {
            $0.setImage(.kakaoLogin, for: .normal)
            $0.alpha = 0
        }
        appleLoginButton.do {
            $0.setImage(.appleLogin, for: .normal)
            $0.alpha = 0
        }
        lastLoginBadgeView.do {
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
            appleLoginButton,
            lastLoginBadgeView
        )
    }
    
    override func setLayout() {
        backgrounImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        appIconImageView.snp.makeConstraints {
            self.appIconTopConstraint = $0.top.equalToSuperview().inset(296.adjustedH).constraint
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180.adjustedW)
            $0.height.equalTo(150.adjustedH)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(appIconImageView.snp.bottom).offset(20.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(17.adjustedH)
        }
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(6.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(28.adjustedH)
        }
        kakaoLoginButton.snp.makeConstraints {
            self.kakaoLoginTopConstraint = $0.top.equalTo(mainTitleLabel.snp.bottom).offset(85.adjustedH).constraint
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(54.adjustedH)
        }
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(12.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(120.adjustedH)
            $0.height.equalTo(54.adjustedH)
        }
        lastLoginBadgeView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom
                .equalTo(kakaoLoginButton.snp.top)
                .offset(20.adjustedH)
        }
    }
}

extension LoginView {
    
    func updateLastLoginBadgeConstraint(provider: Provider?) {
        switch provider {
        case .none:
            lastLoginBadgeView.snp.removeConstraints()
            lastLoginBadgeView.removeFromSuperview()
        case .kakao:
            break
        case .apple:
            lastLoginBadgeView.snp.remakeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom
                    .equalTo(appleLoginButton.snp.top)
                    .offset(20.adjustedH)
            }
        }
    }
}
