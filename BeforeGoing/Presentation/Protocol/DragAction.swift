//
//  DragAction.swift
//  BeforeGoing
//
//  Created by APPLE on 1/13/26.
//

import UIKit

protocol DragAction {
    func makeDragItems() -> [UIDragItem]
}

extension DragAction {
    func makeDragItems() -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}
