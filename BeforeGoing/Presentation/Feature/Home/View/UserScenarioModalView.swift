//
//  HomeModalView.swift
//  BeforeGoing
//
//  Created by APPLE on 8/12/25.
//

import UIKit

import SnapKit

final class UserScenarioModalView: BaseView {
    
    private let maxTaskNameLength = 14
    
    var modalHeightConstraint: Constraint?
    private(set) var currentHeight: CGFloat = 555.adjustedH
    private let maxHeight: CGFloat = 705.adjustedH
    private(set) var minHeight: CGFloat = 555.adjustedH
    
    private(set) var headerView = UserScenarioModalHeaderView()
    private(set) var emptyView = ScenarioEmptyView(type: .home)
    private(set) var taskTextField = TextField(type: .enableAddField)
    private(set) var addTaskButton = UIButton()
    private(set) var deleteTaskButton = UIButton()
    private(set) var listTableView = UITableView()
    
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
            $0.layer.cornerRadius = 20
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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
            $0.bottom.equalToSuperview().inset(20.adjustedH)
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
        let newHeight = currentHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight >= minHeight && newHeight <= maxHeight {
                modalHeightConstraint?.update(offset: newHeight)
            }
        case .ended:
            let threshold = (maxHeight + minHeight) / 2
            newHeight > threshold ? show() : hide()
        default:
            break
        }
    }
}

extension UserScenarioModalView {
    
    func updateText(text: String) {
        guard let text = taskTextField.text,
              !text.isBlank else {
            taskTextField.text = ""
            return
        }
        let completeText = text
            .trim(limit: maxTaskNameLength)
            .removeLeadingSpaces()
        taskTextField.text = completeText
    }
    
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
        currentHeight = maxHeight
        modalHeightConstraint?.update(offset: maxHeight)
        animateLayout()
    }
    
    func hide() {
        currentHeight = minHeight
        modalHeightConstraint?.update(offset: minHeight)
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
