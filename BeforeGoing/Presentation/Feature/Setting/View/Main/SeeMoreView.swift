//
//  MoveMoreView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class SeeMoreView: BaseView {
    
    private let titleLabel = UILabel()
    private(set) var moveButton = UIButton()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        titleLabel.do {
            $0.textColor = .gray900
            $0.font = .custom(.bodyLGMedium)
        }
        moveButton.do {
            $0.setImage(.chevronRight, for: .normal)
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            moveButton
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().inset(20.adjustedW)
        }
        moveButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12.adjustedW)
            $0.size.equalTo(24.adjustedW)
        }
    }
}
