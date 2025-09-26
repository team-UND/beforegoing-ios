//
//  ScenarioViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 7/24/25.
//

import UIKit

final class MyScenarioViewController: BaseViewController {
    
    private let rootView = ScenarioListView()
    private let viewModel: GetScenariosViewModel
    
    init(viewModel: GetScenariosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            do {
                let _ = try await viewModel.action(input: .viewWillAppear)
                rootView.scenarioListTableView.reloadData()
            } catch {
                BeforeGoingLogger.error(BeforeGoingError.getScenariosFailed)
            }
        }
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
        return section == viewModel.scenariosCount - 1 ? 0 : 12
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MyScenarioViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.scenariosCount
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
        
        let name = viewModel.getScenarioName(section: indexPath.section)
        let memo = viewModel.getScenarioMemo(section: indexPath.section)
        
        cell.bind(name: name, memo: memo)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let deleteAction = createDeleteAction(tableView: tableView, indexPath: indexPath)
        let largeConfig = createLargeConfig()
        setDeleteActionStyle(deleteAction: deleteAction, largeConfig: largeConfig)
        
        let config = createSwipeAction(deleteAction: deleteAction)
        
        return config
    }
    
    private func createDeleteAction(tableView: UITableView, indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(
            style: .normal,
            title: nil
        ) { [weak self] (_, view, completion) in
            self?.viewModel.removeScenario(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
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
            )?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.warning600)
        }
    }
    
    private func createSwipeAction(deleteAction: UIContextualAction) -> UISwipeActionsConfiguration {
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
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
            
            viewModel.moveScenario(
                originalAt: sourceSection,
                destinationAt: destinationSection
            )
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
