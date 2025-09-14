//
//  ViewControllerFactory.swift
//  BeforeGoing
//
//  Created by APPLE on 9/14/25.
//

final class ViewControllerFactory {
    
    static let shared = ViewControllerFactory()
    private init() {}
    
    func makeSplashViewController() -> SplashViewController {
        guard let splashViewModel: SplashViewModel = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        return SplashViewController(viewModel: splashViewModel)
    }
    
    func makeLoginViewController() -> LoginViewController {
        guard let loginViewModel: LoginViewModel = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        return LoginViewController(viewModel: loginViewModel)
    }
}
