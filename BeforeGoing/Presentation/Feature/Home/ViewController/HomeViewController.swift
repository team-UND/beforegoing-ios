//
//  HomeViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/11/25.
//

import CoreLocation

import UIKit

final class HomeViewController: BaseViewController {
    
    private let rootView = HomeView()
    private let calendarViewController = CalendarViewController()
    private let homeViewModel: HomeViewModel
    private let getScenariosViewModel: GetAllScenariosViewModel
    private let locationManager = CLLocationManager()
    
    private var homeDate: String?
    private var memberName: String = "워리"
    private var scenarioTitle: String?
    
    init(
        homeViewModel: HomeViewModel,
        getScenariosViewModel: GetAllScenariosViewModel
    ) {
        self.homeViewModel = homeViewModel
        self.getScenariosViewModel = getScenariosViewModel
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
        
        let selectedDate = calendarViewController.selectedDate
        let dateString = DateUtil.toAPIDateString(date: selectedDate)
        
        getScenarios(currentDate: dateString)
        checkLoactionAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocationManager()
        updateDateAndWeather()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override func setAction() {
        setGesture()
        
        rootView.headerView.viewCalendarButton.addTarget(
            self,
            action: #selector(viewCalendarButtonDidTap),
            for: .touchUpInside
        )
        rootView.modalView.headerView.addScenarioButton.addTarget(
            self,
            action: #selector(addScenarioButtonDidTap),
            for: .touchUpInside
        )
        rootView.modalView.taskTextField.addTarget(
            self,
            action: #selector(taskTextFieldEditingChanged),
            for: .editingChanged
        )
        rootView.modalView.deleteTaskButton.addTarget(
            self,
            action: #selector(clearTaskTextField),
            for: .touchUpInside
        )
        rootView.modalView.addTaskButton.addTarget(
            self,
            action: #selector(addTaskButtonDidTap),
            for: .touchUpInside
        )
        rootView.modalView.emptyView.moveButton.addTarget(
            self,
            action: #selector(moveButtonDidTap),
            for: .touchUpInside
        )
        [
            rootView.modalView.weatherKitButtonView.weatherKitButton,
            rootView.modalView.emptyView.weatherKitButtonView.weatherKitButton
        ].forEach {
            $0.addTarget(
                self,
                action: #selector(weatherKitButtonDidTap),
                for: .touchUpInside
            )
        }
        [
            rootView.modalView.weatherKitButtonView,
            rootView.modalView.emptyView.weatherKitButtonView
        ].forEach {
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(weatherKitButtonDidTap)
            )
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGesture)
        }
    }
    
    override func setDelegate() {
        rootView.modalView.listTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(ListItemCell.self, forCellReuseIdentifier: ListItemCell.identifier)
            $0.reloadData()
        }
    }
    
    private func updateDateAndWeather() {
        Task {
            if #available(iOS 17.0, *) {
                try await withThrowingDiscardingTaskGroup { group in
                    group.addTask { [weak self] in
                        try await self?.requestDate()
                    }
                    
                    group.addTask { [weak self] in
                        try await self?.updateWeatherInformation(date: DateUtil.getCurrentDate())
                    }
                }
            } else {
                try await withThrowingTaskGroup(of: Void.self) { group in
                    group.addTask { [weak self] in
                        try await self?.requestDate()
                    }
                    
                    group.addTask { [weak self] in
                        try await self?.updateWeatherInformation(date: DateUtil.getCurrentDate())
                    }
                    
                    try await group.waitForAll()
                }
            }
        }
    }
    
    private func requestDate() async throws {
        do {
            guard let result = try await homeViewModel.action(
                input: .requestDate
            ) as? HomeViewModel.DateOutput,
                  let monthAndDay = DateUtil.toMonthAndDay(date: result.date)
            else {
                return
            }
            self.homeDate = result.date
            rootView.headerView.updateDateUI(date: result.date)
            rootView.modalView.updateTaskField(
                isEnabled: true,
                text: "\(monthAndDay)의 미션을 추가해요"
            )
        } catch (let error) {
            self.handleError(error)
            BeforeGoingLogger.error(error)
        }
    }
    
    private func checkLoactionAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .restricted, .denied, .notDetermined:
            rootView.headerView.updateWeatherUI(information: "설정에서 위치 권한을 허용하시면,\n날씨와 추천 준비물을 알려드려요!")
        @unknown default:
            break
        }
    }
    
    private func getScenarios(currentDate: String) {
        Task {
            let result = try await getScenariosViewModel.action(input: .requestScenarios)
            
            switch result.scenariosResult {
            case .success(let scenarios):
                DispatchQueue.main.async { [weak self] in
                    self?.rootView.modalView.headerView.clear()
                    self?.setGesture(scenarios: scenarios)
                }
                
                let _ = try await homeViewModel.action(
                    input: .scenarioDidTap(
                        scenarioID: getScenariosViewModel.firstScenarioID,
                        date: currentDate
                    )
                )
                
                DispatchQueue.main.async { [weak self] in
                    self?.rootView.modalView.do {
                        $0.replaceModalView()
                        $0.listTableView.reloadData()
                    }
                    
                    if let pendingTitle = self?.scenarioTitle {
                        guard let self,
                              let homeDate = DateUtil.convertDateFormat(dateString: homeDate)
                        else {
                            return
                        }
                        
                        let tag = self.getScenariosViewModel.findTagByTitle(pendingTitle)
                        self.rootView.modalView.headerView.updateTappedLabel(tag: tag)
                        self.fetchScenario(tag: tag, date: homeDate)
                        self.scenarioTitle = nil
                    }
                }
                
            case .failure(let error):
                if let error = error as? BeforeGoingError,
                   error == .notFoundError {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.rootView.modalView.replaceEmptyView(target: self)
                    }
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    self?.handleError(error)
                }
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    private func updateWeatherInformation(date: Date) async throws {
        guard let latitude = locationManager.location?.coordinate.latitude,
              let longitude = locationManager.location?.coordinate.longitude else {
            return
        }
        
        try await getMemberName()
        
        guard let result = try await homeViewModel.action(
            input: .requestWeather(date: date, memberName: memberName, latitude: latitude, longitude: longitude)
        ) as? HomeViewModel.WeatherOutput else {
            return
        }
        
        switch result.weatherResult {
        case .success(let weatherInformation):
            self.rootView.headerView.updateWeatherUI(information: weatherInformation)
        case .failure(let error):
            self.handleError(error)
            BeforeGoingLogger.error(error)
        }
    }
    
    private func getMemberName() async throws {
        do {
            guard let result = try await homeViewModel.action(
                input: .requestName
            ) as? HomeViewModel.MemberNameOutput else {
                return
            }
            
            self.memberName = result.memberName
        } catch {
            BeforeGoingLogger.error(error)
        }
    }
    
    private func setGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(viewCalendarButtonDidTap)
        )
        rootView.headerView.dateStackView.addGestureRecognizer(tapGesture)
    }
    
    private func setGesture(scenarios: [ScenarioEntity]) {
        for (index, scenario) in scenarios.enumerated() {
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(scenarioNameDidTap)
            )
            
            rootView.modalView.headerView.createScenarioItem(
                title: scenario.scenarioName,
                tag: index,
                tapGesture: tapGesture
            )
        }
    }
    
    private func setLocationManager() {
        locationManager.do {
            $0.delegate = self
        }
    }
}

extension HomeViewController: ToastPresentable {
    
    @objc
    private func viewCalendarButtonDidTap() {
        calendarViewController.modalPresentationStyle = .overFullScreen
        
        initSelectedDate(calendarViewController: calendarViewController)
        
        calendarViewController.onDayDidTap = { [weak self] date in
            let dateString = DateUtil.toHomeDateString(date: date)
            let currentDate = DateUtil.getCurrentDate()
            
            guard let self = self,
                  let monthAndDay = DateUtil.toMonthAndDay(date: dateString) else {
                return
            }
            
            updateHomeDate(
                date: date,
                currentDate: currentDate,
                dateString: dateString,
                monthAndDay: monthAndDay
            )
            
            Task {
                try await self.updateWeatherInformation(date: date)
            }
        }
        calendarViewController.onDismiss = { [weak self] in
            guard let homeDate = self?.homeDate,
                  let date = DateUtil.convertDateFormat(dateString: homeDate) else {
                return
            }
            
            self?.getScenarios(currentDate: date)
        }
        self.present(calendarViewController, animated: true)
    }
    
    @objc
    private func addScenarioButtonDidTap() {
        let _ = moveScenarioTab()
    }
    
    @objc
    private func taskTextFieldEditingChanged() {
        guard let text = rootView.modalView.taskTextField.text,
              !text.isEmpty else {
            rootView.modalView.do {
                $0.disableAddTaskButton()
                $0.hideDeleteTaskButton()
            }
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            rootView.modalView.do {
                $0.updateText(text: text)
                $0.enableAddTaskButton()
                $0.revealDeleteTaskButton()
            }
        }
    }
    
    @objc
    private func clearTaskTextField() {
        rootView.modalView.do {
            $0.taskTextField.text = ""
            $0.disableAddTaskButton()
            $0.hideDeleteTaskButton()
        }
    }
    
    @objc
    private func addTaskButtonDidTap() {
        guard let content = rootView.modalView.taskTextField.text,
              !content.isBlank,
              let homeDate = DateUtil.convertDateFormat(dateString: homeDate) else {
            return
        }
        
        clearTaskTextField()
        
        if homeViewModel.isExistMission(content: content) {
            self.presentToastMessage(type: .duplicateMission)
            self.view.endEditing(true)
            return
        }
        
        Task {
            do {
                guard let result = try await homeViewModel.action(
                    input: .addTodayMissionButtonDidTap(
                        scenarioID: getScenariosViewModel.getScenarioID(),
                        date: homeDate,
                        content: content
                    )
                ) as? HomeViewModel.TodayMissionOutput else {
                    return
                }
                
                switch result.todayMissionResult {
                case .success:
                    rootView.modalView.listTableView.reloadData()
                case .failure(let error):
                    if let error = error as? BeforeGoingError {
                        self.handleError(error)
                        if error == .missionLimitError {
                            self.presentToastMessage(type: .todayMissionLimit)
                        }
                    }
                    BeforeGoingLogger.error(error)
                }
                
                self.view.endEditing(true)
            } catch {
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    @objc
    private func scenarioNameDidTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view,
              let homeDate = DateUtil.convertDateFormat(dateString: homeDate) else {
            return
        }
        
        let tag = view.tag
        rootView.modalView.headerView.updateTappedLabel(tag: tag)
        fetchScenario(tag: tag, date: homeDate)
    }
    
    @objc
    private func moveButtonDidTap() {
        guard let bottomViewController = moveScenarioTab(),
              let navigationController = bottomViewController.selectedViewController as? UINavigationController else {
            return
        }
        
        pushMyScenario(navigationController: navigationController)
        pushManageScenario(navigationController: navigationController)
    }
    
    @objc
    private func weatherKitButtonDidTap() {
        ExternalLink.weatherLegal.openURL(for: self)
    }
    
    private func initSelectedDate(calendarViewController: CalendarViewController) {
        if let homeDateString = self.homeDate,
           let date = DateUtil.toDate(dateString: homeDateString) {
            calendarViewController.initialSelectedDate = date
        } else {
            calendarViewController.initialSelectedDate = DateUtil.getCurrentDate()
        }
    }
    
    private func updateHomeDate(
        date: Date,
        currentDate: Date,
        dateString: String,
        monthAndDay: String
    ) {
        self.homeDate = dateString
        updateHeaderDate(date: dateString)
        updateTaskByDate(
            date: date,
            currentDate: currentDate,
            monthAndDay: monthAndDay
        )
    }
    
    private func fetchScenario(tag: Int, date: String) {
        let scenarioID = getScenariosViewModel.getScenarioID(at: tag)
        
        Task {
            guard let result = try await homeViewModel.action(
                input: .scenarioDidTap(
                    scenarioID: scenarioID,
                    date: date
                )
            ) as? HomeViewModel.MissionsOutput else { return }
            
            switch result.missionsResult {
            case .success:
                getScenariosViewModel.updatePointer(to: tag)
                rootView.modalView.listTableView.reloadData()
            case .failure(let error):
                self.handleError(error)
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    private func updateHeaderDate(date: String) {
        self.rootView.headerView.updateDateUI(date: date)
    }
    
    private func updateTaskByDate(
        date: Date,
        currentDate: Date,
        monthAndDay: String
    ) {
        if date >= currentDate {
            self.rootView.modalView.updateTaskField(
                isEnabled: true,
                text: "\(monthAndDay)의 미션을 추가해요"
            )
            return
        }
        self.rootView.modalView.updateTaskField(
            isEnabled: false,
            text: "지난 날짜의 리스트는 추가할 수 없어요"
        )
    }
    
    private func moveScenarioTab() -> BottomNavigationViewController? {
        guard let bottomViewController = self.tabBarController as? BottomNavigationViewController else {
            return nil
        }
        bottomViewController.selectTab(item: .scenario)
        return bottomViewController
    }
    
    private func pushMyScenario(navigationController: UINavigationController) {
        let hasMyScenarioVC = navigationController.viewControllers.contains { $0 is MyScenarioViewController }
        if !hasMyScenarioVC {
            let myScenarioVC = ViewControllerFactory.shared.makeMyScenarioViewController()
            navigationController.pushViewController(myScenarioVC, animated: false)
        }
    }
    
    private func pushManageScenario(navigationController: UINavigationController) {
        let manageScenarioVC = ViewControllerFactory.shared.makeManageScenarioViewController()
        manageScenarioVC.do {
            $0.navigationItem.hidesBackButton = true
            $0.hidesBottomBarWhenPushed = true
        }
        navigationController.pushViewController(manageScenarioVC, animated: true)
    }
}

extension HomeViewController {
    
    func configure(scenarioTitle: String?) {
        self.scenarioTitle = scenarioTitle
    }
}

extension HomeViewController: CLLocationManagerDelegate, NetworkRequestable, NetworkRequestErrorHandler {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLoactionAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        BeforeGoingLogger.error(error)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12.adjustedH
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeViewModel.missionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ListItemCell.identifier,
            for: indexPath
        ) as? ListItemCell else {
            return UITableViewCell()
        }
        
        let missionState = homeViewModel.getMissionState(at: indexPath.section)
        let beforeMissionState = homeViewModel.getBeforeMissionState(at: indexPath.section)
        
        cell.bind(
            itemTitle: homeViewModel.getMissionTitle(at: indexPath.section),
            state: missionState,
            beforeState: beforeMissionState
        )
        
        cell.onCellDidTap = { [weak self] in
            guard let self = self,
                  let homeDate = DateUtil.convertDateFormat(dateString: homeDate) else {
                return
            }
            
            let missionID = self.homeViewModel.getMissionID(at: indexPath.section)
            
            Task {
                do {
                    let _ = try await self.homeViewModel.action(
                        input: .missionChecked(
                            missionID: missionID,
                            date: homeDate,
                            willBeChecked: cell.willBeChecked
                        )
                    )
                    tableView.reloadData()
                    HapticManager.shared.impact()
                } catch (let error) {
                    self.handleError(error)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.adjustedH
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        if !homeViewModel.isTodayMission(at: indexPath.section) {
            return nil
        }
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
            Task {
                guard let missionID = self?.homeViewModel.getMissionID(at: indexPath.section),
                      let result = try await self?.homeViewModel.action(
                        input: .deleteTodayMissionButtonDidTap(
                            missionID: missionID
                        )
                      ) as? HomeViewModel.DeleteTodayMissionOutput else {
                    return
                }
                
                switch result.deleteTodayMissionResult {
                case .success:
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                case .failure(let error):
                    self?.handleError(error)
                    BeforeGoingLogger.error(error)
                }
            }
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
