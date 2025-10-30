//
//  HomeModalView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/12/25.
//

import UIKit

import SnapKit

final class UserScenarioModalView: BaseView {
    
    private(set) var headerView = UserScenarioModalHeaderView()
    private(set) var emptyView = ScenarioEmptyView(type: .home)
    private(set) var taskTextField = TextField(type: .enableAddField)
    private(set) var addTaskButton = UIButton()
    private(set) var deleteTaskButton = UIButton()
    private(set) var listTableView = UITableView()
    
    var bottomConstraint: Constraint?
    private(set) var maxHeight: CGFloat = 705.adjustedH
    private(set) var minHeight: CGFloat = 555.adjustedH
    
    init() {
        super.init(frame: .zero)
        
        setStyle()
        setUI()
        setLayout()
        setGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = .white
        }
        taskTextField.do {
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20.adjustedW, height: 0))
            $0.leftViewMode = .always
        }
        addTaskButton.do {
            $0.setImage(.plusCircle.withTintColor(.gray400), for: .normal)
        }
        deleteTaskButton.do {
            $0.setImage(.union, for: .normal)
            $0.isHidden = true
        }
        listTableView.do {
            $0.separatorStyle = .none
        }
    }
    
    override func setUI() {
        addSubviews(
            headerView,
            taskTextField,
            deleteTaskButton,
            addTaskButton,
            listTableView
        )
    }
    
    override func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(42.adjustedH)
        }
        taskTextField.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(20.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
        }
        addTaskButton.snp.makeConstraints {
            $0.trailing.equalTo(taskTextField.snp.trailing).offset(-20.adjustedW)
            $0.centerY.equalTo(taskTextField.snp.centerY)
            $0.size.equalTo(24.adjustedW)
        }
        deleteTaskButton.snp.makeConstraints {
            $0.trailing.equalTo(addTaskButton.snp.leading)
            $0.centerY.equalTo(taskTextField.snp.centerY)
            $0.size.equalTo(24.adjustedW)
        }
        listTableView.snp.makeConstraints {
            $0.top.equalTo(taskTextField.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setGesture() {
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(handlePan(_:)))
        headerView.addGestureRecognizer(panGesture)
    }
}

extension UserScenarioModalView {
    
    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let superview = superview else { return }
        
        let translation = gesture.translation(in: superview)
        var newOffset = (bottomConstraint?.layoutConstraints.first?.constant ?? 0) + translation.y
        newOffset = min(max(newOffset, 0), maxHeight - minHeight)
        
        bottomConstraint?.update(offset: newOffset)
        gesture.setTranslation(.zero, in: superview)
        
        if gesture.state == .ended {
            newOffset < (maxHeight - minHeight) / 2 ? show() : hide()
        }
    }
}

extension UserScenarioModalView {
    
    func updatePlaceHolder(text: String) {
        taskTextField.placeholder = text
    }
    
    func updateTaskField(isEnable: Bool) {
        taskTextField.currentType = isEnable ? .enableAddField : .disableAddField
        taskTextField.isEnabled = isEnable
    }
    
    func enableAddTaskButton() {
        addTaskButton.setImage(.plusCircle.withTintColor(.blue500), for: .normal)
    }
    
    func disableAddTaskButton() {
        addTaskButton.setImage(.plusCircle.withTintColor(.gray400), for: .normal)
    }
    
    func revealDeleteTaskButton() {
        deleteTaskButton.isHidden = false
    }
    
    func hideDeleteTaskButton() {
        deleteTaskButton.isHidden = true
    }
    
    func show() {
        bottomConstraint?.update(offset: 0)
        animateLayout()
    }
    
    func hide() {
        bottomConstraint?.update(offset: maxHeight - minHeight)
        animateLayout()
    }
    
    private func animateLayout() {
        UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    func replaceEmptyView(target: UIViewController) {
        [
            headerView,
            listTableView,
            taskTextField,
            addTaskButton,
            deleteTaskButton
        ].forEach { $0.removeFromSuperview() }
        addSubview(emptyView)
        emptyView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(80.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.height.equalTo(285.adjustedH)
        }
    }
    
    func replaceModalView() {
        emptyView.removeFromSuperview()
        setUI()
        setLayout()
    }
}
