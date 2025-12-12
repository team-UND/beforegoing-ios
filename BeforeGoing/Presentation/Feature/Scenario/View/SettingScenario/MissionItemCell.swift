//
//  MissionItemcell.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

final class MissionItemCell: UITableViewCell {
    
    private let missionItemView = ScenarioItemView(height: 50)
    
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
        addSubview(missionItemView)
    }
    
    private func setLayout() {
        missionItemView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MissionItemCell {
    
    func bind(mission: String) {
        missionItemView.updateItemName(mission)
    }
}
