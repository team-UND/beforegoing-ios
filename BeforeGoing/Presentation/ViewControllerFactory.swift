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
        let viewModel = resolveViewModel(SplashViewModel.self)
        return SplashViewController(viewModel: viewModel)
    }
    
    func makeLoginViewController() -> LoginViewController {
        let viewModel = resolveViewModel(LoginViewModel.self)
        return LoginViewController(viewModel: viewModel)
    }
    
    func makeProfileViewController() -> ProfileViewController {
        let viewModel = resolveViewModel(ProfileViewModel.self)
        return ProfileViewController(viewModel: viewModel)
    }
    
    func makeAgreeTermsViewController() -> AgreeTermsViewController {
        let viewModel = resolveViewModel(AgreeItemViewModel.self)
        return AgreeTermsViewController(viewModel: viewModel)
    }
    
    func makeNicknameViewController() -> NicknameViewController {
        let viewModel = resolveViewModel(NicknameViewModel.self)
        return NicknameViewController(viewModel: viewModel)
    }
    
    func makeOnboardingViewController() -> OnboardingViewController {
        return OnboardingViewController()
    }
    
    func makeModifyNicknameViewController() -> ModifyNameViewController {
        let viewModel = resolveViewModel(ModifyNicknameViewModel.self)
        return .init(viewModel: viewModel)
    }
    
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController()
    }
    
    func makeMyScenarioViewController() -> MyScenarioViewController {
        return MyScenarioViewController()
    }
    
    func makeSettingViewController() -> SettingViewController {
        let viewModel = resolveViewModel(SettingViewModel.self)
        return .init(viewModel: viewModel)
    }
}

extension ViewControllerFactory {
    
    private func resolveViewModel<T: ViewModeling>(_ type: T.Type) -> T {
        guard let viewModel: T = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        return viewModel
    }
}
