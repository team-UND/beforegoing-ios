//
//  NoticeMethodView.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

final class NoticeMethodView: BaseView {
    
    private(set) var imageView = UIImageView()
    private let methodNameLabel = UILabel()
    private let methodType: NoticeMethodType
    private(set) var radioButton: RadioButton
    
    init(type: NoticeMethodType) {
        self.methodType = type
        self.radioButton = type.component.radioButton
        super.init(frame: .zero)
        
        initProperty(type: type)
    }
    
    private func initProperty(type: NoticeMethodType) {
        let component = type.component
        imageView.image = (type == .push) ? component.selectedImage : component.unSelectedImage
        methodNameLabel.text = component.methodName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        imageView.do {
            $0.contentMode = .scaleAspectFill
        }
        methodNameLabel.do {
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = .custom(.bodyMDMedium)
        }
    }
    
    override func setUI() {
        addSubviews(
            imageView,
            methodNameLabel,
            radioButton
        )
    }
    
    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(240.adjustedH)
        }
        methodNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.centerX.equalTo(imageView.snp.centerX)
        }
        radioButton.snp.makeConstraints {
            $0.top.equalTo(methodNameLabel.snp.bottom).offset(12.adjustedH)
            $0.centerX.equalTo(methodNameLabel.snp.centerX)
        }
    }
}

extension NoticeMethodView {
    
    func updateImage(isSelected: Bool) {
        let component = methodType.component
        imageView.image = isSelected ? component.selectedImage : component.unSelectedImage
    }
}
