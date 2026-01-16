//
//  UITableViewDropDelegate+.swift
//  BeforeGoing
//
//  Created by APPLE on 1/13/26.
//

import UIKit

extension UITableViewDropDelegate {
    
    func handleDrop(
        with coordinator: UITableViewDropCoordinator,
        action: (_ sourceSection: Int, _ destinationSection: Int) -> Void
    ) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else {
            return
        }
        
        let destinationSection = destinationIndexPath.section
        
        for item in coordinator.items {
            guard let sourceIndexPath = item.sourceIndexPath else {
                return
            }
            
            action(sourceIndexPath.section, destinationSection)
        }
    }
    
    func handleDropProposal(dropSessionDidUpdate session: UIDropSession) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
}
