//
//  ProfileFeatureView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/5/25.
//

import UIKit

final class ProfileFeatureView: BaseView {
    
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private(set) var seeMoreButton = UIButton()
    
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundView.do {
            $0.backgroundColor = .gray50
            $0.layer.cornerRadius = 14
        }
        titleLabel.do {
            $0.textColor = .gray900
            $0.font = .custom(.bodyLGMedium)
        }
        seeMoreButton.do {
            $0.setImage(.chevronRight, for: .normal)
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundView,
            titleLabel,
            seeMoreButton
        )
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(48.adjustedH)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(backgroundView.snp.leading).offset(20.adjustedW)
            $0.centerY.equalTo(backgroundView.snp.centerY)
        }
        seeMoreButton.snp.makeConstraints {
            $0.trailing.equalTo(backgroundView.snp.trailing).offset(-20.adjustedW)
            $0.centerY.equalTo(backgroundView.snp.centerY)
            $0.size.equalTo(24.adjustedW)
        }
    }
}
