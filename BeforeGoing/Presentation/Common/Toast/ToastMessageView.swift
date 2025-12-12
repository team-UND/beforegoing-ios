//
//  ToastMessageView.swift
//  BeforeGoing
//
//  Created by APPLE on 11/2/25.
//

import UIKit

final class ToastMessageView: BaseView {
    
    private let textLabel = PaddedLabel()
    
    init(text: String) {
        super.init(frame: .zero)
        self.textLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        textLabel.do {
            $0.backgroundColor = .warning50
            $0.textColor = .warning600
            $0.font = .custom(.bodySMSemiBold)
            $0.textAlignment = .center
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 14
        }
    }
    
    override func setUI() {
        addSubview(textLabel)
    }
    
    override func setLayout() {
        textLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(30.adjustedH)
        }
    }
}
