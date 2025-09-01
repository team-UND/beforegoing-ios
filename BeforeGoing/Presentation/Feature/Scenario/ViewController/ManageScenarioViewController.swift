//
//  ManagerScenarioViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/26/25.
//

import UIKit

final class ManageScenarioViewController: BaseViewController {
    
    private let rootView = ManageScenarioView()
    
    private var templates: [ScenarioType] = [.mine, .outing, .goWork, .leaveWork, .exercise, .miracle]
    private var didCellTap: Bool = false
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TopNavigationBar.makeNavigationBar(
            navigationController: self.navigationController,
            type: .clear
        )
    }
    
    override func setAction() {
        rootView.selectButton.addTarget(
            self,
            action: #selector(selectButtonDidTap),
            for: .touchUpInside
        )
    }
    
    override func setDelegate() {
        rootView.templateTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.dragDelegate = self
            $0.dropDelegate = self
            $0.register(ManageScenarioCell.self, forCellReuseIdentifier: ManageScenarioCell.identifier)
        }
    }
}

extension ManageScenarioViewController {
    
    @objc
    func selectButtonDidTap() {
        let viewController = SettingScenarioViewController()
        viewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(viewController, animated: false)
    }
}

extension ManageScenarioViewController: Backable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension ManageScenarioViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76.adjustedH
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == templates.count - 1 ? 0 : 12
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for visibleIndexPath in tableView.indexPathsForVisibleRows ?? [] {
            guard let cell = tableView.cellForRow(at: visibleIndexPath) as? ManageScenarioCell else {
                return
            }
            cell.isSelected = (visibleIndexPath != indexPath) ? false : true
        }
        if !didCellTap {
            didCellTap = true
            rootView.updateStyle()
        }
    }
}

extension ManageScenarioViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return templates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ManageScenarioCell.identifier,
            for: indexPath
        ) as? ManageScenarioCell else {
            return UITableViewCell()
        }
        
        cell.bind(type: templates[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completionHandler in
            self?.templates.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            completionHandler(true)
        }
        
        deleteAction.image = .trash.withTintColor(.white)
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ManageScenarioViewController: UITableViewDragDelegate {
    
    func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: any UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension ManageScenarioViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        let destinationSection = destinationIndexPath.section
        
        for item in coordinator.items {
            guard let sourceIndexPath = item.sourceIndexPath else { continue }
            let sourceSection = sourceIndexPath.section
            
            let movedSection = templates.remove(at: sourceSection)
            templates.insert(movedSection, at: destinationSection)
        }
        tableView.reloadData()
    }
    
    func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
}
