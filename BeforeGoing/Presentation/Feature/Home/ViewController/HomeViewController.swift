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
    private let homeViewModel: HomeViewModel
    private let getScenariosViewModel: GetScenariosViewModel
    private let locationManager = CLLocationManager()
    
    private var homeDate: String?
    private var memberName: String?
    
    init(
        homeViewModel: HomeViewModel,
        getScenariosViewModel: GetScenariosViewModel
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
        
        getScenarios(currentDate: DateUtil.getCurrentDate(format: "yyyy-MM-dd"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManager()
        
        Task {
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
        
        requestDate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override func setAction() {
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
    }
    
    override func setDelegate() {
        rootView.modalView.listTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(ListItemCell.self, forCellReuseIdentifier: ListItemCell.identifier)
            $0.reloadData()
        }
    }
    
    private func requestDate() {
        Task {
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
                rootView.modalView.updatePlaceHolder(text: "\(monthAndDay)에만 할 일을 추가해주세요")
                rootView.modalView.updateTaskField(isEnable: true)
            } catch (let error) {
                self.handleError(error)
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    private func getScenarios(currentDate: String) {
        Task {
            let result = try await getScenariosViewModel.action(input: .viewWillAppear)
            
            switch result.scenariosResult {
            case .success(let scenarios):
                rootView.modalView.headerView.clear()
                setGesture(scenarios: scenarios)
                let _ = try await homeViewModel.action(
                    input: .scenarioDidTap(
                        scenarioID: getScenariosViewModel.firstScenarioID,
                        date: currentDate
                    )
                )
                rootView.modalView.do {
                    $0.replaceModalView()
                    $0.listTableView.reloadData()
                }
            case .failure(let error):
                if let error = error as? BeforeGoingError,
                   error == .notFoundError {
                    rootView.modalView.replaceEmptyView(target: self)
                    return
                }
                BeforeGoingLogger.error(error)
            }
        }
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
            $0.requestWhenInUseAuthorization()
            checkStatus()
        }
    }
}

extension HomeViewController: ToastPresentable {
    
    @objc
    private func viewCalendarButtonDidTap() {
        let calendar = CalendarViewController()
        calendar.modalPresentationStyle = .overFullScreen
        calendar.onDayDidTap = { [weak self] date in
            let dateString = DateUtil.toString(date: date)
            let currentDate = DateUtil.getCurrentDate()
            
            guard let self = self,
                  let monthAndDay = DateUtil.toMonthAndDay(date: dateString) else {
                return
            }
            
            self.homeDate = dateString
            updateHeaderDate(date: dateString)
            updatePlaceHolderByDate(
                date: date,
                currentDate: currentDate,
                monthAndDay: monthAndDay
            )
            
            if date != currentDate {
                updateWeatherByDate(
                    date: date,
                    currentDate: currentDate,
                    monthAndDay: monthAndDay
                )
                return
            }
            locationManager.requestLocation()
        }
        calendar.onDismiss = { [weak self] in
            guard let homeDate = self?.homeDate,
                  let date = DateUtil.convertDateFormat(dateString: homeDate) else {
                return
            }
            
            self?.getScenarios(currentDate: date)
        }
        self.present(calendar, animated: true)
    }
    
    @objc
    private func addScenarioButtonDidTap() {
        moveMySceario()
    }
    
    @objc
    private func taskTextFieldEditingChanged() {
        if let text = rootView.modalView.taskTextField.text,
           !text.isBlank {
            rootView.modalView.do {
                $0.enableAddTaskButton()
                $0.revealDeleteTaskButton()
            }
            return
        }
        rootView.modalView.do {
            $0.disableAddTaskButton()
            $0.hideDeleteTaskButton()
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
        
        Task {
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
        }
        self.view.endEditing(true)
    }
    
    @objc
    private func scenarioNameDidTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view,
              let homeDate = DateUtil.convertDateFormat(dateString: homeDate) else {
            return
        }
        
        fetchScenario(tag: view.tag, homeDate: homeDate)
    }
    
    @objc
    func handleScenarioTap(title: String) {
        let currentDate = DateUtil.getCurrentDate().toString()
        
        let tag = getScenariosViewModel.findTagByTitle(title)
        rootView.modalView.headerView.updateTappedLabel(tag: tag)
    }
    
    private func fetchScenario(tag: Int, homeDate: String) {
        let scenarioID = getScenariosViewModel.getScenarioID(at: tag)
        
        rootView.modalView.headerView.updateTappedLabel(tag: tag)
        
        Task {
            guard let result = try await homeViewModel.action(
                input: .scenarioDidTap(
                    scenarioID: scenarioID,
                    date: homeDate
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
    
    @objc
    private func moveButtonDidTap() {
        moveMySceario()
    }
    
    private func moveMySceario() {
        guard let bottomViewController = self.tabBarController as? BottomNavigationViewController else {
            return
        }
        bottomViewController.selectTab(item: .scenario)
    }
    
    private func updateHeaderDate(date: String) {
        self.rootView.headerView.updateDateUI(date: date)
    }
    
    private func updateWeatherByDate(
        date: Date,
        currentDate: Date,
        monthAndDay: String
    ) {
        guard let memberName = memberName,
              currentDate != date else {
            return
        }
        
        let scenarioIntroduce = "\(memberName)님의 \(monthAndDay) 시나리오예요!"
        let pastDateIntroduce = "해당 날짜의 기상 정보는 확인하기 어려워요"
        let futureDateIntroduce = "지난 날짜의 기상 정보는 제공하지 않아요"
        let customColor = UIColor.blue700.cgColor
        
        if date > currentDate {
            self.rootView.headerView.updateWeatherUI(
                information: "\(pastDateIntroduce)\n\(scenarioIntroduce)"
                    .customText(rangedText: memberName, color: customColor)
            )
            return
        }
        self.rootView.headerView.updateWeatherUI(
            information: "\(futureDateIntroduce)\n\(scenarioIntroduce)"
                .customText(rangedText: memberName, color: customColor)
        )
    }
    
    private func updatePlaceHolderByDate(condition: Bool, monthAndDay: String) {
        if condition {
            self.rootView.modalView.do {
                $0.updatePlaceHolder(text: "\(monthAndDay)에만 할 일을 추가해주세요")
                $0.updateTaskField(isEnable: true)
            }
            return
        }
        self.rootView.modalView.do {
            $0.updatePlaceHolder(text: "지난 날짜의 리스트는 추가할 수 없어요")
            $0.updateTaskField(isEnable: false)
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate, NetworkRequestable, NetworkRequestErrorHandler {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .restricted, .denied:
            break
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            Task {
                do {
                    guard let result = try await homeViewModel.action(
                        input: .requestWeather(latitude: latitude, longitude: longitude)
                    ) as? HomeViewModel.WeatherOutput else {
                        return
                    }
                    self.rootView.headerView.updateWeatherUI(information: result.weatherResult)
                    manager.stopUpdatingLocation()
                } catch (let error) {
                    self.handleError(error)
                    BeforeGoingLogger.error(error)
                    BeforeGoingLogger.error(BeforeGoingError.requestWeatherFailed)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        BeforeGoingLogger.error(error)
    }
    
    private func checkStatus() {
        let status = locationManager.authorizationStatus
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
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
                            date: homeDate
                        )
                    )
                    tableView.reloadData()
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
