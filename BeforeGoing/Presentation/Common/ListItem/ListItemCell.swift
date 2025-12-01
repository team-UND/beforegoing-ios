//
//  ListItem.swift
//  BeforeGoing
//
//  Created by APPLE on 8/12/25.
//

import UIKit

final class ListItemCell: UITableViewCell {
    
    private var state: ListItemState = .normal
    var onCellDidTap: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.selectionStyle = .none
    }
}

extension ListItemCell {
    
    func bind(itemTitle: String, state: ListItemState, beforeState: ListItemState) {
        self.state = state
        
        let listItem = state.createListItem(beforeState: beforeState)
        setUI(listItem)
        setLayout(listItem)
        setAction(listItem)
        bindItemTitle(listItem, title: itemTitle)
    }
    
    private func setUI(_ listItem: ListItemProtocol) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(listItem)
    }
    
    private func setLayout(_ listItem: ListItemProtocol) {
        listItem.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setAction(_ listItem: ListItemProtocol) {
        listItem.checkBox.addTarget(
            self,
            action: #selector(checkBoxDidTap),
            for: .touchUpInside
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkBoxDidTap))
        listItem.checkBoxView.addGestureRecognizer(tapGesture)
    }
    
    private func bindItemTitle(_ listItem: ListItemProtocol, title: String) {
        listItem.updateText(title)
    }
}

extension ListItemCell {
    
    var willBeChecked: Bool {
        self.state != .completed
    }
    
    @objc
    func checkBoxDidTap(_ sender: UIButton) {
        onCellDidTap?()
    }
}
