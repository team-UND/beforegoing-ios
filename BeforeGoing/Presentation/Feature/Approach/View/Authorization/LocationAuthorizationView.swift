//
//  LocationAuthorizationView.swift
//  BeforeGoing
//
//  Created by APPLE on 10/20/25.
//

import UIKit

final class LocationAuthorizationView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let mainLabel = UILabel()
    private let subLabel = UILabel()
    private let noticeWeatherImageView = UIImageView()
    private(set) var agreeButton = UIButton()
    private(set) var disagreeButton = UIButton()
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgAuthorization
        }
        mainLabel.do {
            $0.text = "현재 위치의 날씨 소식과\n날씨별 추천 준비물을 알려드려요"
            $0.textColor = .gray900
            $0.textAlignment = .left
            $0.font = .custom(.headingH3)
            $0.numberOfLines = 2
        }
        subLabel.do {
            $0.text = "워리의 추천을 위해 위치 접근을 허용해주세요!"
            $0.textColor = .gray400
            $0.textAlignment = .left
            $0.font = .custom(.bodyMDMedium)
        }
        noticeWeatherImageView.image = .locationAuthorization
        agreeButton.do {
            $0.setTitle("날씨 소식을 받을래!", for: .normal)
            $0.setTitleColor(.gray900, for: .normal)
            $0.titleLabel?.font = .custom(.bodyLGSemiBold)
            $0.backgroundColor = .blue400
            $0.layer.cornerRadius = 14
        }
        disagreeButton.do {
            $0.setTitle("지금은 괜찮아", for: .normal)
            $0.setTitleColor(.blue500, for: .normal)
            $0.titleLabel?.font = .custom(.bodyLGSemiBold)
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            mainLabel,
            subLabel,
            noticeWeatherImageView,
            agreeButton,
            disagreeButton
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(60.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(62.adjustedH)
        }
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(4.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(17.adjustedH)
        }
        noticeWeatherImageView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(30.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(403.adjustedH)
        }
        agreeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(94.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(48.adjustedH)
        }
        disagreeButton.snp.makeConstraints {
            $0.top.equalTo(agreeButton.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(48.adjustedH)
        }
    }
}
