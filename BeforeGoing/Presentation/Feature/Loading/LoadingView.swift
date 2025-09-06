//
//  LoadingView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/6/25.
//

import UIKit

final class LoadingView: BaseView {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func setStyle() {
        backgroundColor = .white
        imageView.image = .loadingWorry
        titleLabel.do {
            $0.text = "로딩에 실패했어요:("
            $0.textAlignment = .center
            $0.textColor = .gray900
            $0.font = .custom(.headingH4)
        }
        descriptionLabel.do {
            $0.text = "다시 시도해 주세요!"
            $0.textAlignment = .center
            $0.textColor = .gray400
            $0.font = .custom(.bodyMDMedium)
        }
    }
    
    override func setUI() {
        addSubviews(
            imageView,
            titleLabel,
            descriptionLabel
        )
    }
    
    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(261.5.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(167.89.adjustedW)
            $0.height.equalTo(134.adjustedH)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(23.adjustedH)
            $0.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6.adjustedH)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(306.7.adjustedH)
        }
    }
}
