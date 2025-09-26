//
//  ScenarioListItemView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/24/25.
//

import UIKit

final class ScenarioListItemCell: UITableViewCell {
    
    private let scenarioItemView = ScenarioItemView(height: 76, isExistSubtitle: true)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
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
}

extension ScenarioListItemCell {
    
    func bind(name: String, memo: String) {
        scenarioItemView.do {
            $0.titleLabel.text = name
            $0.subtitleLabel.text = memo
        }
    }
}
