//
//  UITableViewDragDelegate+.swift
//  BeforeGoing
//
//  Created by APPLE on 1/13/26.
//

import UIKit

extension UITableViewDragDelegate {
    
    func provideDragItem() -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}
