//
//  NetworkRequestable.swift
//  BeforeGoing
//
//  Created by APPLE on 10/11/25.
//

protocol NetworkRequestable: AnyObject {
    func presentLoginExpired()
}

extension NetworkRequestable where Self: BaseViewController {
    func presentLoginExpired() {
        let modalViewController = ModalViewController(modalView: ModalView(type: .expirationLogin))
        self.present(modalViewController, animated: false)
    }
}
