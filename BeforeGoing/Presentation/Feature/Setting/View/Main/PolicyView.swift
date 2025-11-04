//
//  PolicyView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class PolicyView: BaseView {
    
    private let titleLabel = UILabel()
    private(set) var noticeView = SeeMoreView(title: "공지사항")
    private(set) var termView = SeeMoreView(title: "이용 약관")
    private(set) var privacyView = SeeMoreView(title: "개인정보 처리방침")
    private let versionTitleLabel = UILabel()
    private(set) var versionLabel = UILabel()
    
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
            $0.textColor = .gray900
            $0.font = .custom(.bodyMDMedium)
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            noticeView,
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
            $0.height.equalTo(29.adjustedH)
        }
        noticeView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(28.adjustedH)
        }
        termView.snp.makeConstraints {
            $0.top.equalTo(noticeView.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(28.adjustedH)
        }
        privacyView.snp.makeConstraints {
            $0.top.equalTo(termView.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(28.adjustedH)
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
