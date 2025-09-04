//
//  MissionItemcell.swift
//  BeforeGoing
//
//  Created by APPLE on 9/3/25.
//

import UIKit

final class MissionItemCell: UITableViewCell {
    
    private let missionItemView = ScenarioItemView(height: 50, isExistSubtitle: false)
    
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
        addSubview(missionItemView)
    }
}

extension MissionItemCell {
    
    func bind(mission: String) {
        missionItemView.titleLabel.text = mission
    }
}
