//
//  TableViewSwipeAction.swift
//  BeforeGoing
//
//  Created by APPLE on 1/13/26.
//

import UIKit

protocol TableViewSwipeAction: AnyObject {
    func createSwipeActionConfig(
        tableView: UITableView,
        indexPath: IndexPath,
        action: @escaping () -> Void
    ) -> UISwipeActionsConfiguration
}

extension TableViewSwipeAction where Self: BaseViewController {
    
    func createSwipeActionConfig(
        tableView: UITableView,
        indexPath: IndexPath,
        action: @escaping () -> Void
    ) -> UISwipeActionsConfiguration {
        let deleteAction = createDeleteAction(
            tableView: tableView,
            indexPath: indexPath) {
                action()
            }
        let largeConfig = createLargeConfig()
        setDeleteActionStyle(deleteAction: deleteAction, largeConfig: largeConfig)
        let config = createSwipeAction(deleteAction: deleteAction)
        
        return config
    }
    
    private func createSwipeAction(deleteAction: UIContextualAction) -> UISwipeActionsConfiguration {
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    private func createDeleteAction(
        tableView: UITableView,
        indexPath: IndexPath,
        action: @escaping () -> Void
    ) -> UIContextualAction {
        return UIContextualAction(
            style: .normal,
            title: nil
        ) { (_, view, completion) in
            action()
            completion(true)
        }
    }
    
    private func createLargeConfig() -> UIImage.SymbolConfiguration {
        return UIImage.SymbolConfiguration(pointSize: 12.0, weight: .bold, scale: .large)
    }
    
    private func setDeleteActionStyle(
        deleteAction: UIContextualAction,
        largeConfig: UIImage.SymbolConfiguration
    ) {
        deleteAction.do {
            $0.backgroundColor = .white
            $0.image = UIImage(
                systemName: "trash",
                withConfiguration: largeConfig
            )?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.warning500)
        }
    }
}
