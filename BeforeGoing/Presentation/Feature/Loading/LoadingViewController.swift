//
//  LoadingViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 9/6/25.
//

final class LoadingViewController: BaseViewController {
    
    private let rootView = LoadingView()
    
    override func loadView() {
        view = rootView
    }
}
