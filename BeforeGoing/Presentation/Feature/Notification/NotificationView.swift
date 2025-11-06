//
//   NotificationView.swift
//  BeforeGoing
//
//  Created by APPLE on 10/7/25.
//

import UIKit

final class NotificationView: BaseView {
    
    private var notificationViewType: NotificationViewType
    private(set) var actionButtons: [UIButton: NotificationAction] = [:]
    
    private let backgroundImageView = UIImageView()
    private let mainTitleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    init(notificationViewType: NotificationViewType, title: String) {
        self.notificationViewType = notificationViewType
        self.backgroundImageView.image = notificationViewType.backgroundImage
        super.init(frame: .zero)
        
        subtitleLabel.text = title
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        mainTitleLabel.do {
            $0.text = "워리 콜"
            $0.textColor = notificationViewType.mainTitleColor
            $0.textAlignment = .center
            $0.font = .custom(.headingH2)
        }
        subtitleLabel.do {
            $0.textColor = .gray900
            $0.textAlignment = .center
            $0.font = .custom(.headingH1)
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            mainTitleLabel,
            subtitleLabel
        )
        
        notificationViewType.actions.forEach { addSubview(createActionView(action: $0)) }
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(48.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(92.adjustedW)
            $0.height.equalTo(36.adjustedH)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(4.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(92.adjustedW)
            $0.height.equalTo(47.adjustedH)
        }
        
        let actionViews = subviews.filter { $0 is UIButton || $0.subviews.contains(where: { $0 is UIButton }) }
        
        switch actionViews.count {
        case 1:
            guard let singleActionView = actionViews.first else { return }
            singleActionView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(40.adjustedH)
            }
            
        case 2:
            let leftActionView = actionViews[0]
            let rightActionView = actionViews[1]
            let sideInset = 44.adjustedW
            
            leftActionView.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(sideInset)
                $0.bottom.equalToSuperview().inset(40.adjustedH)
            }
            rightActionView.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(sideInset)
                $0.bottom.equalToSuperview().inset(40.adjustedH)
            }
            
        default:
            break
        }
    }
    
    private func createActionView(action: NotificationAction) -> UIView {
        let actionView = UIView()
        let actionButton = createActionButton(image: action.image)
        let descriptionLabel = createDescriptionLabel(description: action.description)
        
        actionButtons[actionButton] = action
        
        actionView.addSubviews(actionButton, descriptionLabel)
        
        makeLayoutConstraints(actionView, actionButton, descriptionLabel)
        
        return actionView
    }
    
    private func createActionButton(image: UIImage) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        
        return button
    }
    
    private func createDescriptionLabel(description: String) -> UILabel {
        let textLabel = UILabel()
        textLabel.do {
            $0.text = description
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = .custom(.bodyMDSemiBold)
        }
        
        return textLabel
    }
    
    private func makeLayoutConstraints(
        _ actionView: UIView,
        _ actionButton: UIButton,
        _ descriptionLabel: UILabel
    ) {
        actionView.snp.makeConstraints {
            $0.width.equalTo(72.adjustedW)
            $0.height.equalTo(95.adjustedH)
        }
        actionButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.size.equalTo(72.adjustedW)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(actionButton.snp.bottom).offset(6.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.width.equalTo(72.adjustedW)
            $0.height.equalTo(17.adjustedH)
        }
    }
}
