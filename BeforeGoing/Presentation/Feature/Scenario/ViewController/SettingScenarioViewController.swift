//
//  SettingScenarioViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/1/25.
//

import UIKit

final class SettingScenarioViewController: BaseViewController {
    
    private let rootView = SettingScenarioView()
    private var missions: [String] = []
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(false)
    }
    
    override func setAction() {
        rootView.inputScenarioView.textField.addTarget(
            self,
            action: #selector(scenarioNameTextFieldDidTap),
            for: .editingChanged
        )
        rootView.inputMemoView.textField.addTarget(
            self,
            action: #selector(memoTextFieldDidTap),
            for: .editingChanged
        )
        rootView.inputScenarioView.deleteButton.addTarget(
            self,
            action: #selector(scenarioDeleteButtonDidTap),
            for: .touchUpInside
        )
        rootView.inputMemoView.deleteButton.addTarget(
            self,
            action: #selector(memoDeleteButtonDidTap),
            for: .touchUpInside
        )
        rootView.settingMissionView.missionTextField.addTarget(
            self,
            action: #selector(missionTextFieldDidTap),
            for: .editingChanged
        )
        rootView.settingMissionView.deleteMissionButton.addTarget(
            self,
            action: #selector(deleteMissionButtonDidTap),
            for: .touchUpInside
        )
        rootView.settingMissionView.addMissionButton.addTarget(
            self,
            action: #selector(addMissionButtonDidTap),
            for: .touchUpInside
        )
        rootView.nextButton.addTarget(
            self,
            action: #selector(nextButtonDidTap),
            for: .touchUpInside
        )
    }
    
    override func setDelegate() {
        rootView.settingMissionView.missionTableView.do {
            $0.register(MissionItemCell.self, forCellReuseIdentifier: MissionItemCell.identifier)
            $0.delegate = self
            $0.dataSource = self
            $0.dragDelegate = self
            $0.dropDelegate = self
        }
    }
}

extension SettingScenarioViewController: Backable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension SettingScenarioViewController {
    
    func configure(scenarioType: ScenarioType) {
        switch scenarioType {
        case .mine:
            rootView.inputScenarioView.do {
                let mine = "나만의 시나리오"
                $0.textField.text = mine
                $0.updateTextCount(mine.count)
            }
        default:
            rootView.inputScenarioView.do {
                let scenario = scenarioType.rawValue
                $0.textField.text = scenario
                $0.updateTextCount(scenario.count)
            }
        }
    }
}

extension SettingScenarioViewController {
    
    @objc
    private func scenarioNameTextFieldDidTap() {
        bindTextField(view: rootView.inputScenarioView)
    }
    
    @objc
    private func memoTextFieldDidTap() {
        bindTextField(view: rootView.inputMemoView)
    }
    
    private func bindTextField(view: InputInformationView) {
        guard let text = view.textField.text else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard self != nil else { return }
            
            text.isEmpty ? view.hideDeleteButton() : view.revealDeleteButton()
            let trimmedText = view.trimText(text)
            view.updateTextCount(trimmedText.count)
        }
        checkNextButtonState()
    }
    
    @objc
    private func scenarioDeleteButtonDidTap() {
        rootView.inputScenarioView.deleteAllText()
    }
    
    @objc
    private func memoDeleteButtonDidTap() {
        rootView.inputMemoView.deleteAllText()
    }
    
    @objc
    private func missionTextFieldDidTap() {
        rootView.settingMissionView.revealDeleteButton()
        guard let text = rootView.settingMissionView.missionTextField.text else { return }
        rootView.settingMissionView.deleteMissionButton.isHidden = text.isEmpty ? true : false
    }
    
    @objc
    private func deleteMissionButtonDidTap() {
        rootView.settingMissionView.deleteAllText()
    }
    
    @objc
    private func addMissionButtonDidTap() {
        guard let mission = rootView.settingMissionView.getUserMission(),
                !mission.isEmpty else { return }
        missions.insert(mission, at: 0)
        rootView.settingMissionView.missionTableView.insertSections(
            IndexSet(integer: 0),
            with: .automatic
        )
        checkNextButtonState()
        self.view.endEditing(false)
    }
    
    @objc
    private func nextButtonDidTap() {
        let viewController = NoticeViewController()
        viewController.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    private func checkNextButtonState() {
        guard let scenario = rootView.inputScenarioView.textField.text,
              let memo = rootView.inputMemoView.textField.text else { return }
        let isEnabled = !scenario.isEmpty && !memo.isEmpty && missions.count >= 1
        
        rootView.updateUI(state: isEnabled ? .enableLongButton : .disableLongButton)
    }
}

extension SettingScenarioViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == missions.count - 1 ? 0 : 12
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension SettingScenarioViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return missions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MissionItemCell.identifier,
            for: indexPath
        ) as? MissionItemCell else {
            return UITableViewCell()
        }
        cell.bind(mission: missions[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completionHandler in
            self?.missions.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            self?.checkNextButtonState()
            completionHandler(true)
        }
        
        deleteAction.image = .trash.withTintColor(.white)
        deleteAction.backgroundColor = .red
                
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension SettingScenarioViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension SettingScenarioViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        let destinationSection = destinationIndexPath.section
        
        for item in coordinator.items {
            guard let sourceIndexPath = item.sourceIndexPath else { continue }
            let sourceSection = sourceIndexPath.section
            
            let movedSection = missions.remove(at: sourceSection)
            missions.insert(movedSection, at: destinationSection)
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
