//
//  LocationAuthorizationView.swift
//  BeforeGoing
//
//  Created by APPLE on 10/20/25.
//

import UIKit

final class LocationAuthorizationView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let backgroundCharacterView = UIImageView()
    private let mainLabel = UILabel()
    private let subLabel = UILabel()
    private let notificationsImageView = UIImageView()
    private(set) var agreeButton = UIButton()
    private(set) var disagreeButton = UIButton()
    
    override func setStyle() {
        backgroundImageView.image = .bgSplash
        backgroundCharacterView.image = .bgCharacter
        mainLabel.do {
            $0.text = "날씨에 대비할 수 있도록,\n위치 권한을 허용해보세요"
            $0.textColor = .gray900
            $0.textAlignment = .left
            $0.font = .custom(.headingH3)
            $0.numberOfLines = 2
        }
        subLabel.do {
            $0.text = "위치 권한 허용 유무는 언제든지 바꿀 수 있어요!"
            $0.textColor = .gray400
            $0.textAlignment = .left
            $0.font = .custom(.bodyMDMedium)
        }
        notificationsImageView.image = .notifications
        agreeButton.do {
            $0.setTitle("위치 권한을 허용할래!", for: .normal)
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
            backgroundCharacterView,
            mainLabel,
            subLabel,
            notificationsImageView,
            agreeButton,
            disagreeButton
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundCharacterView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(79.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(112.adjustedH)
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
        notificationsImageView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(244.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(133.4.adjustedH)
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
