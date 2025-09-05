//
//  PolicyView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class PolicyView: BaseView {
    
    private let titleLabel = UILabel()
    private(set) var termView = SeeMoreView(title: "이용 약관")
    private(set) var privacyView = SeeMoreView(title: "개인정보 처리방침")
    private let versionTitleLabel = UILabel()
    private let versionLabel = UILabel()
    
    override func setStyle() {
        titleLabel.do {
            $0.text = "정책 및 정보"
            $0.textColor = .gray400
            $0.font = .custom(.bodyLGSemiBold)
        }
        versionTitleLabel.do {
            $0.text = "버전 정보"
            $0.textColor = .gray900
            $0.font = .custom(.bodyLGMedium)
        }
        versionLabel.do {
            $0.text = "v.1.5.11"
            $0.textColor = .gray900
            $0.font = .custom(.bodyMDMedium)
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            termView,
            privacyView,
            versionTitleLabel,
            versionLabel
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20.adjustedW)
        }
        termView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        privacyView.snp.makeConstraints {
            $0.top.equalTo(termView.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        versionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(privacyView.snp.bottom).offset(16.adjustedH)
            $0.leading.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview()
        }
        versionLabel.snp.makeConstraints {
            $0.centerY.equalTo(versionTitleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalToSuperview()
        }
    }
}
