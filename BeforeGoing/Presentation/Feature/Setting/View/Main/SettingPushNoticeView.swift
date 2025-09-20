//
//  SettingPushNoticeView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class SettingPushNoticeView: BaseView {
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private(set) var switchButton = UISwitch()
    
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
        subtitleLabel.do {
            $0.text = "설정하신 시간 별, 위치 별 알림을 받아볼 수 있어요."
            $0.textColor = .gray400
            $0.font = .custom(.bodyMDMedium)
        }
        switchButton.do {
            $0.isOn = false
            $0.onTintColor = .blue400
            $0.layer.cornerRadius = 12
            setThumbSize()
        }
    }
    
    private func setThumbSize() {
        if let thumb = switchButton.subviews.first?.subviews.last?.subviews.last {
            let scale: CGFloat = 0.67
            thumb.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            subtitleLabel,
            switchButton
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20.adjustedW)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(20.adjustedW)
        }
        switchButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2.adjustedH)
            $0.trailing.equalToSuperview().inset(28.adjustedW)
            $0.width.equalTo(40.adjustedW)
            $0.height.equalTo(24.adjustedH)
        }
    }
}

extension SettingPushNoticeView {
    
    func updateButtonState(condition: Bool) {
        switchButton.isOn = condition
    }
}
