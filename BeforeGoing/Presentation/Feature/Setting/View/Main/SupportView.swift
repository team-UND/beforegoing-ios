//
//  SupportView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class SupportView: BaseView {
    
    private let titleLabel = UILabel()
    private(set) var seemoreView = SeeMoreView(title: "문의하기")
    private let divider = UILabel()
    
    override func setStyle() {
        titleLabel.do {
            $0.text = "지원"
            $0.textColor = .gray400
            $0.font = .custom(.bodyLGSemiBold)
        }
        divider.do {
            $0.backgroundColor = .gray50
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            seemoreView,
            divider
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20.adjustedW)
        }
        seemoreView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        divider.snp.makeConstraints {
            $0.top.equalTo(seemoreView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(6.adjustedH)
            $0.bottom.equalToSuperview()
        }
    }
}
