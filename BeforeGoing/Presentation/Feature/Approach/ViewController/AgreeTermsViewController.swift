//
//  AgreeTermsViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import UIKit

final class AgreeTermsViewController: BaseViewController {
    
    private let topNavigationView = TopNavigationView(title: "약관동의")
    private let rootView = AgreeTermsView()
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
        view.addSubview(rootView)
        rootView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setAction() {
        setGesture()
        rootView.do {
            $0.checkBox.addTarget(self, action: #selector(mainCheckBoxDidTap), for: .touchUpInside)
            $0.agreeButton.addTarget(self, action: #selector(agreeButtonDidTap), for: .touchUpInside)
        }
    }
    
    override func setDelegate() {
        rootView.tableView.do {
            $0.dataSource = self
            $0.register(AgreeItemCell.self, forCellReuseIdentifier: AgreeItemCell.identifier)
            $0.reloadData()
        }
    }
    
    private func setGesture() {
        let mainTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(mainCheckBoxDidTap)
        )
        rootView.agreeToAllLabel.do {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(mainTapGesture)
        }
    }
}

extension AgreeTermsViewController {
    
    @objc
    private func mainCheckBoxDidTap() {
        let checkBoxState = rootView.checkBox.toggle()
        
        viewModel.toggleAllItems(checkBoxState: checkBoxState)
        rootView.updateAgreement(isEnabled: viewModel.isAllNecssaryChecked)
        rootView.tableView.reloadData()
    }
    
    @objc
    private func agreeButtonDidTap() {
        var output: AgreeItemViewModel.Output = .agreeTermsResult(false)
        Task {
            output = try await viewModel.action(input: .nextButtonDidTap)
        }
        
        switch output {
        case .agreeTermsResult(let isSucceed):
            if isSucceed {
                let nicknameViewController = ViewControllerFactory.shared.makeNicknameViewController()
                self.navigationController?.pushViewController(nicknameViewController, animated: false)
                return
            }
            BeforeGoingLogger.error(BeforeGoingError.agreeTermsFailed)
        }
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
            checkBoxState: viewModel.getState(item: item)
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
        rootView.updateAgreement(isEnabled: viewModel.isAllNecssaryChecked)
    }
    
    private func updateCheckBoxState() {
        rootView.checkBox.updateState(isEnabled: viewModel.isAllChecked)
    }
}
