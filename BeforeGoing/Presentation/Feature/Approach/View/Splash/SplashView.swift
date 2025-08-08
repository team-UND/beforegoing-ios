//
//  SplashView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import UIKit

final class SplashView: BaseView {
    
    private let backgrounImageView = UIImageView()
    private let appIconImageView = UIImageView()
    private let subtitleLabel = UILabel()
    private let mainTitleLabel = UILabel()
    
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
    }
    
    override func setUI() {
        addSubviews(
            backgrounImageView,
            appIconImageView,
            subtitleLabel,
            mainTitleLabel
        )
    }
    
    override func setLayout() {
        backgrounImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        appIconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(311.adjustedH)
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
    }
}
