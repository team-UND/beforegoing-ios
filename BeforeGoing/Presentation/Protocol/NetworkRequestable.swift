//
//  NetworkRequestable.swift
//  BeforeGoing
//
//  Created by APPLE on 10/11/25.
//

protocol NetworkRequestable: AnyObject {
    func presentLoginExpired()
    func presentTooManyRequest()
}

extension NetworkRequestable where Self: BaseViewController {
    func presentLoginExpired() {
        presentModal(modalType: .expirationLogin)
    }
    
    func presentTooManyRequest() {
        presentModal(modalType: .tooManyRequest)
    }
    
    private func presentModal(modalType: ModalType) {
        let modalView = ModalView(type: modalType)
        let modalViewController = ModalViewController(modalView: modalView)
        self.present(modalViewController, animated: true)
    }
}
