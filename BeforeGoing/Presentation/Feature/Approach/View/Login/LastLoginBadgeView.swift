//
//  LastLoginBadgeView.swift
//  BeforeGoing
//
//  Created by APPLE on 11/21/25.
//

import UIKit

final class LastLoginBadgeView: BaseView {
    
    private let speechBubbleView = UIView()
    private let circleView = UIView()
    private let speechTextLabel = UILabel()
    
    override func setStyle() {
        speechBubbleView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16.5
        }
        circleView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8
        }
        speechTextLabel.do {
            $0.text = "최근에 로그인 했어요!"
            $0.textColor = .blue700
            $0.textAlignment = .center
            $0.font = .custom(.bodyMDMedium)
        }
    }
    
    override func setUI() {
        addSubviews(
            speechBubbleView,
            speechTextLabel,
            circleView
        )
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(168.adjustedW)
            $0.height.equalTo(41.adjustedH)
        }
        speechBubbleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(144.adjustedW)
            $0.height.equalTo(33.adjustedH)
        }
        speechTextLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(speechBubbleView.snp.verticalEdges).inset(8.adjustedH)
            $0.center.equalTo(speechBubbleView.snp.center)
        }
        circleView.snp.makeConstraints {
            $0.top.equalTo(speechBubbleView.snp.bottom).offset(-9.adjustedH)
            $0.centerX.equalTo(speechBubbleView.snp.centerX)
            $0.bottom.equalToSuperview().inset(4.adjustedH)
            $0.size.equalTo(16.adjustedW)
        }
    }
}
