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
        agreeTermsView.do {
            $0.checkBox.addTarget(self, action: #selector(mainCheckBoxDidTap), for: .touchUpInside)
            $0.agreeButton.addTarget(self, action: #selector(agreeButtonDidTap), for: .touchUpInside)
        }
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
    
    @objc
    private func mainCheckBoxDidTap() {
        let checkBoxState = agreeTermsView.checkBox.toggle()
        
        viewModel.toggleAllItems(checkBoxState: checkBoxState)
        viewModel.isAllNecssaryChecked ? agreeTermsView.enableAgreement() : agreeTermsView.disableAgreement()
        agreeTermsView.tableView.reloadData()
    }
    
    @objc
    private func agreeButtonDidTap() {
        let nicknameViewController = NicknameViewController()
        self.navigationController?.pushViewController(nicknameViewController, animated: false)
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
        
        let item = AgreeItem.allCases[indexPath.row]
        
        cell.bind(
            item: item,
            checkBoxState: agreeTermsView.checkBox.currentState
        )
        cell.onDidTap = { [weak self] checkBoxState in
            guard let self = self else { return }
            self.viewModel.toggleItem(item: item, checkBoxState: checkBoxState)
            updateAgreementButtonState()
            updateCheckBoxState()
        }
        
        return cell
    }
    
    private func updateAgreementButtonState() {
        viewModel.isAllNecssaryChecked ? agreeTermsView.enableAgreement() : agreeTermsView.disableAgreement()
    }
    
    private func updateCheckBoxState() {
        agreeTermsView.checkBox.currentState = viewModel.isAllChecked ? .checked : .unchecked
    }
}
