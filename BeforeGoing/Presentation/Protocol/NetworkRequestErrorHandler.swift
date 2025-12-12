//
//  NetworRequestErrorHandler.swift
//  BeforeGoing
//
//  Created by APPLE on 11/4/25.
//

protocol NetworkRequestErrorHandler: AnyObject {
    func handleError(_ error: Error)
}

extension NetworkRequestErrorHandler where Self: BaseViewController & NetworkRequestable {
    func handleError(_ error: Error) {
        guard let error = error as? BeforeGoingError else {
            return
        }
        
        switch error {
        case .loginExpired:
            presentLoginExpired()
        case .tooManyRequset:
            presentTooManyRequest()
        case .serviceUnavailable, .unknownError:
            presentServiceUnavailable()
        default:
            break
        }
    }
}
