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
    private(set) var weatherKitButtonView = WeatherKitButtonView(
        frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 52.adjustedH)
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
            $0.image = type.isHome ? .exclamation : .starWorry
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
            addSubviews(
                moveButton,
                weatherKitButtonView
            )
        }
    }
    
    override func setLayout() {
        worryImageView.snp.makeConstraints {
            let topInset = type.isHome ? 20.adjustedH : 0
            $0.top.equalToSuperview().inset(topInset)
            
            $0.centerX.equalToSuperview()
            
            let imageSize = type.isHome ? 48.adjustedW : 200.adjustedW
            $0.size.equalTo(imageSize)
        }
        titleLabel.snp.makeConstraints {
            let topOffset = type.isHome ? 20.adjustedH : 10.adjustedH
            $0.top.equalTo(worryImageView.snp.bottom).offset(topOffset)
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
            }
            weatherKitButtonView.snp.makeConstraints {
                $0.top.equalTo(moveButton.snp.bottom).offset(110.adjustedH)
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            }
        }
    }
}
