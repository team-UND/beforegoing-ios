//
//  ScenarioListItemView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/24/25.
//

import UIKit

final class ScenarioListItemCell: UITableViewCell {
    
    private let scenarioItemView = ScenarioItemView(height: 76)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
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
}

extension ScenarioListItemCell {
    
    func bind(type: ScenarioType) {
        scenarioItemView.do {
            $0.titleLabel.text = type.rawValue
            $0.subtitleLabel.text = type.subtitle
        }
    }
}
