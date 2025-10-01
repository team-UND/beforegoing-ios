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
        
        Task { @MainActor in
            let result = try await getScenariosViewModel.action(input: .viewWillAppear)
            
            switch result.scenariosResult {
            case .success(let scenarios):
                rootView.modalView.headerView.clear()
                
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
                
                let _ = try await homeViewModel.action(
                    input: .scenarioDidTap(
                        scenarioID: getScenariosViewModel.firstScenarioID,
                        date: DateUtil.getCurrentDate(format: "yyyy-MM-dd")
                    )
                )
                rootView.modalView.listTableView.reloadData()
            case .failure(let error):
                BeforeGoingLogger.error(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManager()
        
        Task {
            do {
                guard let result = try await homeViewModel.action(
                    input: .requestDate
                ) as? HomeViewModel.DateOutput else {
                    return
                }
                rootView.headerView.updateDateUI(date: result.date)
            } catch {
                BeforeGoingLogger.error(error)
            }
        }
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
    }
    
    override func setDelegate() {
        rootView.modalView.listTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(ListItemCell.self, forCellReuseIdentifier: ListItemCell.identifier)
            $0.reloadData()
        }
    }
    
    private func setLocationManager() {
        locationManager.do {
            $0.delegate = self
            $0.desiredAccuracy = kCLLocationAccuracyBest
            $0.requestAlwaysAuthorization()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways,
           CLLocationManager.locationServicesEnabled() {
            manager.requestLocation()
        }
    }
}

extension HomeViewController {
    
    @objc
    private func viewCalendarButtonDidTap() {
        let calendar = CalendarViewController()
        calendar.modalPresentationStyle = .overFullScreen
        self.present(calendar, animated: true)
    }
    
    @objc
    private func taskTextFieldEditingChanged() {
        if let text = rootView.modalView.taskTextField.text,
           !text.isEmpty {
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
              !content.isEmpty else {
            return
        }
        
        clearTaskTextField()
        let date = DateUtil.getCurrentDate(format: "yyyy-MM-dd")
        
        Task {
            guard let result = try await homeViewModel.action(
                input: .addTodayMissionButtonDidTap(
                    scenarioID: getScenariosViewModel.getScenarioID(),
                    date: date,
                    content: content
                )
            ) as? HomeViewModel.TodayMissionOutput else {
                return
            }
            
            switch result.todayMissionResult {
            case .success:
                rootView.modalView.listTableView.reloadData()
            case .failure(let error):
                BeforeGoingLogger.error(error)
            }
        }
        self.view.endEditing(true)
    }
    
    @objc
    private func scenarioNameDidTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        
        let tag = view.tag
        let scenarioID = getScenariosViewModel.getScenarioID(at: tag)
        let currentDate = DateUtil.getCurrentDate(format: "yyyy-MM-dd")
        
        Task {
            guard let result = try await homeViewModel.action(
                input: .scenarioDidTap(
                    scenarioID: scenarioID,
                    date: currentDate
                )
            ) as? HomeViewModel.MissionsOutput else { return }
            
            switch result.missionsResult {
            case .success:
                rootView.modalView.listTableView.reloadData()
            case .failure(let error):
                BeforeGoingLogger.error(error)
            }
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
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
                    self.rootView.headerView.updateWeatherUI(weather: result.weatherResult)
                    manager.stopUpdatingLocation()
                } catch (let error) {
                    BeforeGoingLogger.error(error)
                    BeforeGoingLogger.error(BeforeGoingError.requestWeatherFailed)
                }
            }
        }
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
            guard let self = self else { return }
            
            self.homeViewModel.completeMission(at: indexPath.section)
            let missionID = self.homeViewModel.getMissionID(at: indexPath.section)
            let date = DateUtil.getCurrentDate(format: "yyyy-MM-dd")
            
            Task {
                let _ = try await self.homeViewModel.action(
                    input: .missionChecked(
                        missionID: missionID,
                        date: date
                    )
                )
                tableView.reloadData()
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
            )?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.warning600)
        }
    }
    
    private func createSwipeAction(deleteAction: UIContextualAction) -> UISwipeActionsConfiguration {
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}
