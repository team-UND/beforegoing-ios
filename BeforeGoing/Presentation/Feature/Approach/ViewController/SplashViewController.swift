//
//  SplashViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import UIKit

final class SplashViewController: BaseViewController {
    
    private let rootView = SplashView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let viewController = AgreeTermsViewController(viewModel: AgreeItemViewModel())
            viewController.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
