//
//  ScenarioViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 7/24/25.
//

import UIKit

final class MyScenarioViewController: BaseViewController {
    
    private let rootView = ScenarioListView()
    
    // TO-DO 실제 데이터로 대체
    private var scenarios: [ScenarioType] = [.outing, .goWork, .leaveWork, .exercise, .miracle]
    
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
        rootView.addScenarioButton.addTarget(
            self,
            action: #selector(addScenarioButtonDidTap),
            for: .touchUpInside
        )
    }
    
    override func setDelegate() {
        rootView.scenarioListTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.dragDelegate = self
            $0.dropDelegate = self
            $0.register(ScenarioListItemCell.self, forCellReuseIdentifier: ScenarioListItemCell.identifier)
        }
    }
}

extension MyScenarioViewController {
    
    @objc
    private func addScenarioButtonDidTap() {
        let viewController = ManageScenarioViewController()
        viewController.navigationItem.hidesBackButton = true
        viewController.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(viewController, animated: false)
    }
}

extension MyScenarioViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76.adjustedH
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == scenarios.count - 1 ? 0 : 12
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MyScenarioViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return scenarios.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScenarioListItemCell.identifier,
            for: indexPath) as? ScenarioListItemCell else {
            return UITableViewCell()
        }
        
        cell.bind(type: scenarios[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completionHandler in
            self?.scenarios.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            completionHandler(true)
        }
        
        deleteAction.image = .trash.withTintColor(.white)
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension MyScenarioViewController: UITableViewDragDelegate {
    
    func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: any UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension MyScenarioViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        let destinationSection = destinationIndexPath.section
        
        for item in coordinator.items {
            guard let sourceIndexPath = item.sourceIndexPath else { continue }
            let sourceSection = sourceIndexPath.section
            
            let movedSection = scenarios.remove(at: sourceSection)
            scenarios.insert(movedSection, at: destinationSection)
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
