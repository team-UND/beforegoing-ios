//
//  ManagerScenarioViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/26/25.
//

import UIKit

final class ManageScenarioViewController: BaseViewController {
    
    private let rootView = ManageScenarioView()
    private let viewModel: ManageScenarioViewModel
    
    private var didCellTap: Bool = false
    private var selectedIndex: Int?
    private var scenarioNames: [String]?
    
    init(viewModel: ManageScenarioViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        guard let selectedIndex = selectedIndex,
              let scenarioType = viewModel.findScenarioType(index: selectedIndex) else {
            return
        }
        
        let viewController = ViewControllerFactory.shared.makeSettingScenarioViewController()
        
        viewController.navigationItem.hidesBackButton = true
        viewController.configure(
            scenarioType: scenarioType,
            enterType: .addScenario,
            scenarioNames: scenarioNames
        )
        
        self.navigationController?.pushViewController(viewController, animated: false)
    }
}

extension ManageScenarioViewController {
    
    func configure(scenarioNames: [String]) {
        self.scenarioNames = scenarioNames
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
        return section == viewModel.templateCount - 1 ? 0 : 12
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.section
        
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

extension ManageScenarioViewController: UITableViewDataSource, TableViewSwipeAction {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.templateCount
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
        
        guard let scenarioType = viewModel.findScenarioType(index: indexPath.section) else {
            return UITableViewCell()
        }
        
        cell.bind(type: scenarioType)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        return createSwipeActionConfig(tableView: tableView, indexPath: indexPath) { [weak self] in
            let _ = self?.viewModel.removeScenarioType(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        }        
    }
}

extension ManageScenarioViewController: UITableViewDragDelegate {
    
    func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: any UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        provideDragItem()
    }
}

extension ManageScenarioViewController: UITableViewDropDelegate {
    
    func tableView(
        _ tableView: UITableView,
        performDropWith coordinator: UITableViewDropCoordinator
    ) {
        handleDrop(with: coordinator) { sourceSection, destinationSection in
            guard let movedSection = viewModel.removeScenarioType(at: sourceSection) else {
                return
            }
            viewModel.addScenarioType(movedSection, at: destinationSection)
        }
        
        tableView.reloadData()
    }
    
    func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UITableViewDropProposal {
        handleDropProposal(dropSessionDidUpdate: session)
    }
}
