//
//  ViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 7/22/25.
//

import UIKit

import Then
import SnapKit

final class ViewController: BaseViewController {
    
    private let rootView = BeforeGoingNavigationView(title: "나에게 딱 맞는\n템플릿을 선택하세요")
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        BeforeGoingNavigationBar.makeNavigationBar(
            navigationController: self.navigationController,
            type: .none
        )
    }
}

extension ViewController: Backable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}
