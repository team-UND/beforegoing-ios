//
//  ScenarioEmptyView.swift
//  BeforeGoing
//
//  Created by APPLE on 10/3/25.
//

import UIKit

final class ScenarioEmptyView: BaseView {
    
    private let worryImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override func setStyle() {
        worryImageView.do {
            $0.image = .starWorry
        }
        titleLabel.do {
            $0.text = "등록된 시나리오가 없어요"
            $0.textColor = .gray900
            $0.textAlignment = .center
            $0.font = .custom(.headingH4)
        }
        subtitleLabel.do {
            $0.text = "버튼을 눌러 시나리오를 만들어 보세요:)"
            $0.textColor = .gray400
            $0.textAlignment = .center
            $0.font = .custom(.bodyMDMedium)
        }
    }
    
    override func setUI() {
        addSubviews(
            worryImageView,
            titleLabel,
            subtitleLabel
        )
    }
    
    override func setLayout() {
        worryImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(200.adjustedW)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(worryImageView.snp.bottom).offset(10.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26.adjustedH)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(17.adjustedH)
        }
    }
}
