//
//  SettingScenarioViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/1/25.
//

import UIKit

final class SettingScenarioViewController: BaseViewController {
    
    private let rootView = SettingScenarioView()
    
    private let missionLimit = 20
    private var missions: [(missionID: Int?, content: String)] = []
    private var scenarioID: Int?
    private var enterType: SettingScenarioEnterType?
    private var isNotificationActive: Bool?
    private var daysOfWeek: [Int]?
    private var startHour: Int?
    private var startMinute: Int?
    private var notificationMethod: NoticeMethodType?
    
    private let addScenarioViewModel: AddScenarioViewModel
    private let updateScenarioViewModel: UpdateScenarioViewModel
    
    init(
        addScenarioViewModel: AddScenarioViewModel,
        updateScnearioViewModel: UpdateScenarioViewModel
    ) {
        self.addScenarioViewModel = addScenarioViewModel
        self.updateScenarioViewModel = updateScnearioViewModel
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
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
    
    func configure(
        scenarioType: ScenarioType,
        enterType: SettingScenarioEnterType
    ) {
        self.enterType = enterType
        
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
    
    func configure(
        scenarioID: Int,
        scenarioName: String,
        memo: String,
        missions: [(missionID: Int, content: String)],
        isNotificationActive: Bool,
        daysOfWeek: [Int]?,
        startHour: Int?,
        startMinute: Int?,
        notificationMethod: NoticeMethodType?,
        enterType: SettingScenarioEnterType
    ) {
        self.scenarioID = scenarioID
        self.isNotificationActive = isNotificationActive
        self.daysOfWeek = daysOfWeek
        self.startHour = startHour
        self.startMinute = startMinute
        self.notificationMethod = notificationMethod
        self.enterType = enterType

        missions.forEach { self.missions.append(($0.missionID, $0.content)) }
        rootView.inputScenarioView.do {
            $0.textField.text = scenarioName
            $0.updateTextCount(scenarioName.count)
        }
        rootView.inputMemoView.do {
            $0.textField.text = memo
            $0.updateTextCount(memo.count)
        }
        rootView.settingMissionView.missionTableView.reloadData()
        checkNextButtonState()
    }
}

extension SettingScenarioViewController: ToastPresentable {
    
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
            
            text.isBlank ? view.hideDeleteButton() : view.revealDeleteButton()
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
        
        rootView.settingMissionView.deleteMissionButton.isHidden = text.isBlank ? true : false
        rootView.settingMissionView.updateText()
    }
    
    @objc
    private func deleteMissionButtonDidTap() {
        rootView.settingMissionView.deleteAllText()
    }
    
    @objc
    private func addMissionButtonDidTap() {
        guard let missionContent = rootView.settingMissionView.getUserMission(),
              !missionContent.isBlank else { return }
        
        if missions.count >= missionLimit {
            self.presentToastMessage(type: .missionLimit)
            return
        }
        if missions.contains(where: { _, content in
            content == missionContent
        }) {
            self.presentToastMessage(type: .duplicateMission)
            return
        }
        
        missions.insert((nil, missionContent), at: 0)
        rootView.settingMissionView.updateMissionCount(missions.count)
        rootView.settingMissionView.missionTableView.insertSections(
            IndexSet(integer: 0),
            with: .automatic
        )
        checkNextButtonState()
        rootView.settingMissionView.deleteAllText()
        self.view.endEditing(false)
    }
    
    @objc
    private func nextButtonDidTap() {
        guard let scenarioName = rootView.inputScenarioView.textField.text,
              let memo = rootView.inputMemoView.textField.text,
              let enterType = enterType else {
            return
        }
        
        if enterType.isAddScenarioType {
            addScenario(scenarioName: scenarioName, memo: memo)
            return
        }
        updateScenario(scenarioName: scenarioName, memo: memo)
    }
    
    private func checkNextButtonState() {
        guard let scenario = rootView.inputScenarioView.textField.text,
              let memo = rootView.inputMemoView.textField.text else { return }
        let isEnabled = !scenario.isBlank && !memo.isBlank && missions.count >= 1
        
        rootView.updateUI(state: isEnabled ? .enableLongButton : .disableLongButton)
    }
    
    private func addScenario(scenarioName: String, memo: String) {
        let scenarioName = scenarioName.removeTrailingSpaces()
        let memo = memo.removeTrailingSpaces()

        Task {
            do {
                let _ = try await addScenarioViewModel.action(
                    input: .nextButtonInSetScenarioDidTap(
                        scenarioName: scenarioName,
                        memo: memo,
                        basicMissions: missions.map { $0.content }
                    )
                )
                moveNotice(enterType: .addScenario)
            } catch {
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    private func updateScenario(scenarioName: String, memo: String) {
        guard let scenarioID = scenarioID else { return }

        let scenarioName = scenarioName.removeTrailingSpaces()
        let memo = memo.removeTrailingSpaces()
        
        Task {
            do {
                let _ = try await updateScenarioViewModel.action(
                    input: .nextButtonInSetScenarioDidTap(
                        scenarioID: scenarioID,
                        scenarioName: scenarioName,
                        memo: memo,
                        basicMissions: missions
                    )
                )
                moveNotice(enterType: .updateScenario)
            } catch {
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    private func moveNotice(enterType: SettingScenarioEnterType) {
        let viewController = ViewControllerFactory.shared.makeNoticeViewController()
        viewController.navigationItem.hidesBackButton = true
        viewController.configure(
            isNotificationActive: isNotificationActive,
            daysOfWeek: daysOfWeek,
            startHour: startHour,
            startMinute: startMinute,
            notificationMethod: notificationMethod,
            enterType: enterType
        )
        self.navigationController?.pushViewController(viewController, animated: false)
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
        cell.bind(mission: missions[indexPath.section].content)
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
            self?.missions.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            self?.checkNextButtonState()
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
    
    private func createSwipeAction(deleteAction: UIContextualAction) -> UISwipeActionsConfiguration {
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
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
