//
//  LocationAuthorizationViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 10/20/25.
//

import CoreLocation
import Foundation
import UIKit

final class LocationAuthorizationViewController: BaseViewController {
    
    private let rootView = LocationAuthorizationView()
    private let locationManager = CLLocationManager()
    
    override func loadView() {
        view = rootView
    }
    
    override func setAction() {
        rootView.agreeButton.addTarget(
            self,
            action: #selector(agreeButtonDidTap),
            for: .touchUpInside
        )
        rootView.disagreeButton.addTarget(
            self,
            action: #selector(disagreeButtonDidTap),
            for: .touchUpInside
        )
    }
}

extension LocationAuthorizationViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        moveHome()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        BeforeGoingLogger.error(error)
        moveHome()
    }
}

extension LocationAuthorizationViewController {
    
    @objc
    private func agreeButtonDidTap() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            requestAuthorization()
        case .restricted, .denied:
            moveSetting()
        case .authorizedAlways, .authorizedWhenInUse:
            moveHome()
        @unknown default:
            moveHome()
        }
    }
    
    @objc
    private func disagreeButtonDidTap() {
        moveHome()
    }
    
    private func requestAuthorization() {
        locationManager.do {
            $0.delegate = self
            $0.requestAlwaysAuthorization()
        }
    }
    
    private func moveSetting() {
        DispatchQueue.main.async {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url) { [weak self] isOpened in
                    if isOpened {
                        self?.moveHome()
                    }
                }
            }
        }
    }
    
    private func moveHome() {
        let viewController = BottomNavigationViewController()
        ViewControllerUtil.replaceRootViewController(to: viewController)
    }
}
