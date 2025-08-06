//
//  AgreeTermsViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import UIKit

final class AgreeTermsViewController: BaseViewController {
    
    private let topNavigationView = TopNavigationView(title: "약관동의")
    private let agreeTermsView = AgreeTermsView()
    private let viewModel: AgreeItemViewModel
    
    init(viewModel: AgreeItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setAction()
        setDelegate()
        sink()
    }
    
    override func setView() {
        TopNavigationBar.makeNavigationBar(
            navigationController: self.navigationController,
            type: .clear
        )
        view.addSubview(agreeTermsView)
        agreeTermsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setAction() {
        agreeTermsView.checkBox.addTarget(self, action: #selector(mainCheckBoxDidTap), for: .touchUpInside)
    }
    
    override func setDelegate() {
        agreeTermsView.tableView.do {
            $0.dataSource = self
            $0.register(AgreeItemCell.self, forCellReuseIdentifier: AgreeItemCell.identifier)
            $0.reloadData()
        }
    }
}

extension AgreeTermsViewController {
    
    private func sink() {
        viewModel.output.currentAgreeItem.bind { [weak self] agreeItems in
            guard let self = self else { return }
            
            for (index, item) in AgreeItem.allCases.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                guard let cell = self.agreeTermsView.tableView.cellForRow(at: indexPath) as? AgreeItemCell,
                      let state = agreeItems[item] else { return }
                
                cell.do {
                    $0.bind(item: item, checkBoxState: state)
                    $0.onDidTap = { [weak self] (item, checkBoxState) in
                        guard let self = self else { return }
                        updateAgreeTerms(item: item, checkBoxState: checkBoxState)
                    }
                }
            }
        }
    }
    
    private func updateAgreeTerms(item: AgreeItem, checkBoxState: CheckBoxState) {
        let isNecessaryAllChecked = self.viewModel.bindItem(item, checkBoxState: checkBoxState)
        isNecessaryAllChecked ? self.agreeTermsView.enableAgreement() : self.agreeTermsView.disableAgreement()
        
        let isAllChecked = self.viewModel.isAllChecked()
        self.agreeTermsView.checkBox.currentState = isAllChecked ? .checked : .unchecked
    }
}

extension AgreeTermsViewController {
    
    @objc
    private func mainCheckBoxDidTap() {
        agreeTermsView.checkBox.toggle()
        let isAllChecked = viewModel.bindAll(checkBoxState: agreeTermsView.checkBox.currentState)
        isAllChecked ? self.agreeTermsView.enableAgreement() : self.agreeTermsView.disableAgreement()
    }
}

extension AgreeTermsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AgreeItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AgreeItemCell.identifier,
            for: indexPath
        ) as? AgreeItemCell else {
            return UITableViewCell()
        }
        
        cell.bind(
            item: AgreeItem.allCases[indexPath.row],
            checkBoxState: agreeTermsView.checkBox.currentState
        )
        
        return cell
    }
}
