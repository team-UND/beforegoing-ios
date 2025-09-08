//
//  HomeViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/11/25.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    private let homeView = HomeView()
    // 실제 데이터로 대체
    private var items: [(title: String, state: ListItemState, beforeState: ListItemState)] = [
        ("우산 챙기기", .today, .today),
        ("콘센트 빼기", .normal, .normal),
        ("난방 끄기", .normal, .normal),
        ("준비물 챙기기", .normal, .normal),
        ("물 한 잔 마시기", .normal, .normal)
    ]
    
    override func loadView() {
        view = homeView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(false)
    }
    
    override func setAction() {
        homeView.headerView.viewCalendarButton.addTarget(
            self,
            action: #selector(viewCalendarButtonDidTap),
            for: .touchUpInside
        )
        homeView.modalView.taskTextField.addTarget(
            self,
            action: #selector(taskTextFieldEditingChanged),
            for: .editingChanged
        )
        homeView.modalView.deleteTaskButton.addTarget(
            self,
            action: #selector(clearTaskTextField),
            for: .touchUpInside
        )
        homeView.modalView.addTaskButton.addTarget(
            self,
            action: #selector(addTaskButtonDidTap),
            for: .touchUpInside
        )
    }
    
    override func setDelegate() {
        homeView.modalView.listTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(ListItemCell.self, forCellReuseIdentifier: ListItemCell.identifier)
            $0.reloadData()
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
        if let text = homeView.modalView.taskTextField.text,
           !text.isEmpty {
            homeView.modalView.do {
                $0.enableAddTaskButton()
                $0.revealDeleteTaskButton()
            }
            return
        }
        homeView.modalView.do {
            $0.disableAddTaskButton()
            $0.hideDeleteTaskButton()
        }
    }
    
    @objc
    private func clearTaskTextField() {
        homeView.modalView.do {
            $0.taskTextField.text = ""
            $0.disableAddTaskButton()
            $0.hideDeleteTaskButton()
        }
    }
    
    @objc
    private func addTaskButtonDidTap() {
        guard let task = homeView.modalView.taskTextField.text else { return }
        clearTaskTextField()
        items.insert((title: task, state: .today, beforeState: .today), at: 0)
        homeView.modalView.listTableView.reloadData()
        self.view.endEditing(false)
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
        return items.count
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
        cell.bind(
            itemTitle: items[indexPath.section].title,
            state: items[indexPath.section].state,
            beforeState: items[indexPath.section].beforeState
        )
        
        cell.onCellDidTap = { [weak self] in
            guard let self = self else { return }
            
            var selectedItem = self.items.remove(at: indexPath.section)
            selectedItem.state = .completed
            items.append(selectedItem)
            
            tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.adjustedH
    }
    
    func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        if self.items[indexPath.section].state != .today {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] _, _, completionHandler in
            self?.items.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            completionHandler(true)
        }

        deleteAction.do {
            $0.image = .trash.withTintColor(.white)
            $0.backgroundColor = .red
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

}
