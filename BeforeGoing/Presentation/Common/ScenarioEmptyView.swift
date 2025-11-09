//
//  ScenarioEmptyView.swift
//  BeforeGoing
//
//  Created by APPLE on 10/3/25.
//

import UIKit

final class ScenarioEmptyView: BaseView {
    
    private let type: ScenarioEmptyViewType
    
    private let worryImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private(set) var moveButton = CustomButton(
        state: .addScenarioButton,
        title: "+ 시나리오 추가"
    )
    
    init(type: ScenarioEmptyViewType) {
        self.type = type
        super.init(frame: .zero)
        
        self.titleLabel.text = type.title
        self.subtitleLabel.text = type.subtitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        worryImageView.do {
            $0.image = .starWorry
            $0.contentMode = .scaleAspectFill
        }
        titleLabel.do {
            $0.textColor = .gray900
            $0.textAlignment = .center
            $0.font = .custom(.headingH4)
        }
        subtitleLabel.do {
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
        if type.isHome {
            addSubview(moveButton)
        }
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
        if type.isHome {
            moveButton.snp.makeConstraints {
                $0.top.equalTo(subtitleLabel.snp.bottom).offset(26.adjustedH)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(139.adjustedW)
                $0.height.equalTo(48.adjustedH)
                $0.bottom.equalToSuperview()
            }
        }
    }
}
