//
//  ViewControllerFactory.swift
//  BeforeGoing
//
//  Created by APPLE on 9/14/25.
//

final class ViewControllerFactory {
    
    static let shared = ViewControllerFactory()
    private init() {}
    
    func makeLoginViewController() -> LoginViewController {
        let viewModel = resolveViewModel(LoginViewModel.self)
        return .init(viewModel: viewModel)
    }
    
    func makeProfileViewController() -> ProfileViewController {
        let viewModel = resolveViewModel(ProfileViewModel.self)
        return .init(viewModel: viewModel)
    }
    
    func makeAgreeTermsViewController() -> AgreeTermsViewController {
        let viewModel = resolveViewModel(AgreeItemViewModel.self)
        return .init(viewModel: viewModel)
    }
    
    func makeNicknameViewController() -> NicknameViewController {
        let nicknameViewModel = resolveViewModel(NicknameViewModel.self)
        let agreeItemViewModel = resolveViewModel(AgreeItemViewModel.self)
        return .init(
            nicknameViewModel: nicknameViewModel,
            agreeItemViewModel: agreeItemViewModel
        )
    }
    
    func makeOnboardingViewController() -> OnboardingViewController {
        let viewModel = resolveViewModel(OnboardingViewModel.self)
        return OnboardingViewController(viewModel: viewModel)
    }
    
    func makeModifyNicknameViewController() -> ModifyNameViewController {
        let viewModel = resolveViewModel(ModifyNicknameViewModel.self)
        return .init(viewModel: viewModel)
    }
    
    func makeHomeViewController() -> HomeViewController {
        let homeViewModel = resolveViewModel(HomeViewModel.self)
        let getScenariosViewModel = resolveViewModel(GetScenariosViewModel.self)
        return HomeViewController(
            homeViewModel: homeViewModel,
            getScenariosViewModel: getScenariosViewModel
        )
    }
    
    func makeMyScenarioViewController() -> MyScenarioViewController {
        let getSingleScenarioViewModel = resolveViewModel(GetSingleScenarioViewModel.self)
        let getScenariosViewModel = resolveViewModel(GetScenariosViewModel.self)
        let deleteScenarioViewModel = resolveViewModel(DeleteScenarioViewModel.self)
        let updateScenarioOrderViewModel = resolveViewModel(UpdateScenarioOrderViewModel.self)
        
        return MyScenarioViewController(
            getSingleScenarioViewModel: getSingleScenarioViewModel,
            getScenariosViewModel: getScenariosViewModel,
            deleteScenarioViewModel: deleteScenarioViewModel,
            updateScenarioOrderViewModel: updateScenarioOrderViewModel
        )
    }
    
    func makeManageScenarioViewController() -> ManageScenarioViewController {
        let manageScenarioViewModel = resolveViewModel(ManageScenarioViewModel.self)
        
        return ManageScenarioViewController(viewModel: manageScenarioViewModel)
    }
    
    func makeSettingViewController() -> SettingViewController {
        let viewModel = resolveViewModel(SettingViewModel.self)
        return .init(viewModel: viewModel)
    }
    
    func makeSettingScenarioViewController() -> SettingScenarioViewController {
        let addScenarioViewModel = resolveViewModel(AddScenarioViewModel.self)
        let updateScenarioViewModel = resolveViewModel(UpdateScenarioViewModel.self)
        return .init(
            addScenarioViewModel: addScenarioViewModel,
            updateScnearioViewModel: updateScenarioViewModel
        )
    }
    
    func makeSetNoticeMethodViewController() -> SetNoticeMethodViewController {
        let addScenarioViewModel = resolveViewModel(AddScenarioViewModel.self)
        let updateScenarioViewModel = resolveViewModel(UpdateScenarioViewModel.self)
        return .init(
            addScenarioViewModel: addScenarioViewModel,
            updateScenarioViewModel: updateScenarioViewModel
        )
    }
    
    func makeNoticeViewController() -> NoticeViewController {
        let addScenarioViewModel = resolveViewModel(AddScenarioViewModel.self)
        let updateScenarioViewModel = resolveViewModel(UpdateScenarioViewModel.self)
        return .init(
            addScenarioViewModel: addScenarioViewModel,
            updateScenarioViewModel: updateScenarioViewModel
        )
    }
    
    func makeAlarmAuthorizationViewController() -> AlarmAuthorizationViewController {
        return .init()
    }
    
    func makeLocationAuthorizationViewController() -> LocationAuthorizationViewController {
        return .init()
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
