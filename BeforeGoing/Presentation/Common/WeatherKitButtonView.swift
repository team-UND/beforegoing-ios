//
//  WeatherKitButtonView.swift
//  BeforeGoing
//
//  Created by APPLE on 1/7/26.
//

import UIKit

final class WeatherKitButtonView: BaseView {
    
    private(set) var weatherKitButton = UIButton()
    
    override func setStyle() {
        weatherKitButton.do {
            $0.setTitle(" Weather", for: .normal)
            $0.setTitleColor(.gray400, for: .normal)
            $0.titleLabel?.font = .custom(.bodySMMedium)
            $0.titleLabel?.textAlignment = .center
        }
    }
    
    override func setUI() {
        addSubview(weatherKitButton)
    }
    
    override func setLayout() {
        weatherKitButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.adjustedH)
            $0.bottom.equalToSuperview().inset(30.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(80.adjustedW)
        }
    }
}
