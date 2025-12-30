//
//  NetworkRequestable.swift
//  BeforeGoing
//
//  Created by APPLE on 10/11/25.
//

protocol NetworkRequestable: AnyObject {
    func presentTooManyRequest()
    func presentServiceUnavailable()
}

extension NetworkRequestable where Self: BaseViewController {
    
    func presentTooManyRequest() {
        presentModal(modalType: .tooManyRequest)
    }
    
    func presentServiceUnavailable() {
        presentModal(modalType: .serviceUnavailable)
    }
    
    private func presentModal(modalType: ModalType) {
        let modalView = ModalView(type: modalType)
        let modalViewController = ModalViewController(
            modalView: modalView,
            action: { self.dismiss(animated: true) }
        )
        self.present(modalViewController, animated: true)
    }
}
