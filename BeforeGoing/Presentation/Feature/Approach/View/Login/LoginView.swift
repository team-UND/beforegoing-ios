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
    private(set) var startButton = UIButton()
        
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
        startButton.do {
            $0.setTitle("시작하기", for: .normal)
            $0.setTitleColor(.gray600, for: .normal)
            $0.titleLabel?.font = .custom(.bodyLGSemiBold)
            $0.layer.cornerRadius = 14
            $0.backgroundColor = .white
        }
    }
    
    override func setUI() {
        addSubviews(
            backgrounImageView,
            appIconImageView,
            subtitleLabel,
            mainTitleLabel,
            startButton
        )
    }
    
    override func setLayout() {
        backgrounImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        appIconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(223.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180.adjustedW)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(appIconImageView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(17.adjustedH)
        }
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(6.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(28.adjustedH)
        }
        startButton.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(85.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview().inset(120.adjustedH)
            $0.height.equalTo(54.adjustedH)
        }
    }
}
