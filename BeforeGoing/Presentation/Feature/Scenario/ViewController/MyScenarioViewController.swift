//
//  ScenarioViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 7/24/25.
//

import UIKit

final class MyScenarioViewController: BaseViewController, NetworkRequestable, NetworkRequestErrorHandler {
    
    private let rootView = ScenarioListView()
    private let getSingleScenarioViewModel: GetSingleScenarioViewModel
    private let getScenariosViewModel: GetScenariosViewModel
    private let deleteScenarioViewModel: DeleteScenarioViewModel
    private let updateScenarioOrderViewModel: UpdateScenarioOrderViewModel
    
    init(
        getSingleScenarioViewModel: GetSingleScenarioViewModel,
        getScenariosViewModel: GetScenariosViewModel,
        deleteScenarioViewModel: DeleteScenarioViewModel,
        updateScenarioOrderViewModel: UpdateScenarioOrderViewModel
    ) {
        self.getSingleScenarioViewModel = getSingleScenarioViewModel
        self.getScenariosViewModel = getScenariosViewModel
        self.deleteScenarioViewModel = deleteScenarioViewModel
        self.updateScenarioOrderViewModel = updateScenarioOrderViewModel
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
                let result = try await getScenariosViewModel.action(input: .viewWillAppear)
                
                switch result.scenariosResult {
                case .success:
                    rootView.replaceScenarioView()
                    rootView.scenarioListTableView.reloadData()
                case .failure(let error):
                    if let error = error as? BeforeGoingError {
                        if error == .notFoundError {
                            rootView.replaceEmptyView()
                        }
                        self.handleError(error)
                    }
                }
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
        viewController.do {
            $0.navigationItem.hidesBackButton = true
            $0.hidesBottomBarWhenPushed = true
        }
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @objc
    private func scenarioListItemCellDidTap(at: Int) {
        Task {
            do {
                let result = try await getSingleScenarioViewModel.action(
                    input: .scenarioListItemCellDidTap(
                        scenarioID: getScenariosViewModel.getScenarioID(at: at)
                    )
                )
                handleGetScenarioResult(result: result.getScenarioResult)
            } catch {
                self.handleError(error)
            }
        }
    }
    
    private func handleGetScenarioResult(result: Result<ScenarioWithNotificationEntity, Error>) {
        switch result {
        case .success(let scenario):
            moveSettingScenario(scenario: scenario)
        case .failure(let error):
            BeforeGoingLogger.error(error)
        }
    }
    
    private func moveSettingScenario(scenario: ScenarioWithNotificationEntity) {
        let viewController = ViewControllerFactory.shared.makeSettingScenarioViewController()
        viewController.do {
            $0.navigationItem.hidesBackButton = true
            $0.hidesBottomBarWhenPushed = true
            $0.configure(
                scenarioID: scenario.scenarioID,
                scenarioName: scenario.scenarioName,
                memo: scenario.memo,
                missions: scenario.basicMissions.map { (missionID: $0.missionId, content: $0.content) },
                isNotificationActive: scenario.notification.isActive,
                daysOfWeek: scenario.notification.activeData?.daysOfWeekOrdinal,
                startHour: scenario.notificationCondition?.startHour,
                startMinute: scenario.notificationCondition?.startMinute,
                notificationMethod: scenario.notification.activeData?.notificationMethodType,
                enterType: .updateScenario
            )
        }
        self.navigationController?.pushViewController(viewController, animated: false)
    }
}

extension MyScenarioViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76.adjustedH
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == getScenariosViewModel.scenariosCount - 1 ? 0 : 12
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MyScenarioViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return getScenariosViewModel.scenariosCount
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
        
        bindCell(to: cell, section: indexPath.section)
        cell.onDidTap = { [weak self] in
            self?.scenarioListItemCellDidTap(at: indexPath.section)
        }
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
    
    private func bindCell(to cell: ScenarioListItemCell, section: Int) {
        let name = getScenariosViewModel.getScenarioName(section: section)
        let memo = getScenariosViewModel.getScenarioMemo(section: section)
        cell.bind(name: name, memo: memo)
    }
    
    private func createDeleteAction(tableView: UITableView, indexPath: IndexPath) -> UIContextualAction {
        return UIContextualAction(
            style: .normal,
            title: nil
        ) { [weak self] (_, view, completion) in
            Task {
                guard let self = self else { return }
                
                let scenarioID = self.getScenariosViewModel.getScenarioID(at: indexPath.section)
                do {
                    let _ = try await self.deleteScenarioViewModel.action(
                        input: .deleteButtonDidTap(scenarioID: scenarioID)
                    )
                    self.getScenariosViewModel.removeScenario(at: indexPath.section)
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                    
                    if self.getScenariosViewModel.isEmpty {
                        self.rootView.replaceEmptyView()
                    }
                    
                } catch {
                    self.handleError(error)
                    BeforeGoingLogger.error(error)
                }
                completion(true)
            }
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
            
            moveScenario(originalAt: sourceSection, destinationAt: destinationSection)
            updateScenarioOrder(originalAt: sourceSection, destinationAt: destinationSection)
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
    
    private func moveScenario(originalAt: Int, destinationAt: Int) {
        getScenariosViewModel.moveScenario(
            originalAt: originalAt,
            destinationAt: destinationAt
        )
    }
    
    private func updateScenarioOrder(originalAt: Int, destinationAt: Int) {
        guard originalAt != destinationAt else {
            return
        }
    
        let scenarioID = getScenariosViewModel.getScenarioID(at: destinationAt)
        let prevOrder = getScenariosViewModel.getPreviousScenarioOrder(current: destinationAt)
        let nextOrder = getScenariosViewModel.getNextScenarioOrder(current: destinationAt)
        
        Task {
            do {
                let result = try await updateScenarioOrderViewModel.action(
                    input: .scenarioDidDrag(
                        scenarioID: scenarioID,
                        prevOrder: prevOrder,
                        nextOrder: nextOrder
                    )
                )
                handleUpdateScenarioOrderResult(result: result.updateScenarioOrderResult)
            } catch {
                self.handleError(error)
            }
        }
    }
    
    private func handleUpdateScenarioOrderResult(result: Result<NewScenarioOrderEntity, Error>) {
        switch result {
        case .success(let result):
            reflectMyScenario(orderUpdates: result.orderUpdates)
        case .failure(let error):
            BeforeGoingLogger.error(error)
        }
    }
    
    private func reflectMyScenario(orderUpdates: [NewOrderEntity]) {
        getScenariosViewModel.updateOrder(updates: orderUpdates)
        getScenariosViewModel.sortScenario()
        rootView.scenarioListTableView.reloadData()
    }
}
