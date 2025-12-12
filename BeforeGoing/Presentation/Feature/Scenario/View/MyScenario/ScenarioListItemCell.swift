//
//  ScenarioListItemView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/24/25.
//

import UIKit

final class ScenarioListItemCell: UITableViewCell {
    
    private let scenarioItemView = ScenarioItemView(height: 76)
    var onDidTap: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.selectionStyle = .none
    }
    
    private func setUI() {
        addSubview(scenarioItemView)
    }
    
    private func setLayout() {
        scenarioItemView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellDidTap))
        self.do {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGesture)
        }
    }
}

extension ScenarioListItemCell {
    
    @objc
    private func cellDidTap() {
        onDidTap?()
    }
}

extension ScenarioListItemCell {
    
    func bind(name: String, noticeInformation: String?) {
        scenarioItemView.updateItemName(name)
        
        if let noticeInformation {
            scenarioItemView.showSubtitle(noticeInformation)
            return
        }
        scenarioItemView.hideSubtitle()
    }
}
