//
//  BeforeGoingNavigationView.swift
//  BeforeGoing
//
//  Created by APPLE on 7/24/25.
//

import UIKit

final class TopNavigationView: BaseView {
        
    private let containerView = UIView()
    let backButton = UIButton()
    private let titleLabel = UILabel()
    
    init(title: String) {
        self.titleLabel.text = title
        super.init(frame: .zero)
        
        setStyle()
        setUI()
        setLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backButton.do {
            $0.setImage(.chevronLeft, for: .normal)
            $0.tintColor = .black
            $0.isUserInteractionEnabled = true
        }
        titleLabel.do {
            $0.font = .custom(.headingH3)
            $0.textColor = .black
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }
    }
    
    override func setUI() {
        addSubview(containerView)
        containerView.addSubviews(
            backButton,
            titleLabel
        )
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.width.equalTo(375.adjustedW)
            $0.height.equalTo(48.adjustedH)
        }
        backButton.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top)
            $0.width.height.equalTo(48.adjustedW)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.top).offset(10.adjustedH)
            $0.leading.equalTo(backButton.snp.trailing).offset(3.adjustedW)
        }
    }
    
    private func setAction() {
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
}

extension TopNavigationView {
    
    @objc
    func backButtonDidTap() {
        (self.findPresentViewController() as? Backable)?.back()
    }
}
