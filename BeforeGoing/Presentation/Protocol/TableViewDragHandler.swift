//
//  TableViewDragHandler.swift
//  BeforeGoing
//
//  Created by APPLE on 1/13/26.
//

import UIKit

final class TableViewDragHandler: NSObject, UITableViewDragDelegate {
    
    static let shared = TableViewDragHandler()
    
    private override init() {}
    
    func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: any UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}
