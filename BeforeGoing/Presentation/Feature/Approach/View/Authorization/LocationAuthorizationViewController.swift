//
//  LocationAuthorizationViewController.swift
//  BeforeGoing
//
//  Created by APPLE on 10/20/25.
//

import Foundation
import CoreLocation

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
    
    @objc
    private func agreeButtonDidTap() {
        locationManager.do {
            $0.delegate = self
            $0.requestAlwaysAuthorization()
        }
        checkStatus(locationManager.authorizationStatus)
    }
    
    @objc
    private func disagreeButtonDidTap() {
        moveHome()
    }
    
    private func moveHome() {
        let viewController = BottomNavigationViewController()
        ViewControllerUtil.replaceRootViewController(to: viewController)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkStatus(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        BeforeGoingLogger.error(error)
        moveHome()
    }
    
    private func checkStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            moveHome()
        case .restricted, .denied:
            moveHome()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
