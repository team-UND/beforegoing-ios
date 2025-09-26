//
//  PresentationDependencyResembler.swift
//  BeforeGoing
//
//  Created by APPLE on 9/14/25.
//

struct PresentationDependencyAssembler: DependencyAssembler {
    
    private let domainDependencyAssembler: DomainDependencyAssembler
    
    init(preAssembler: DomainDependencyAssembler) {
        self.domainDependencyAssembler = preAssembler
    }
    
    func assemble() {
        domainDependencyAssembler.assemble()
        
        guard let loginUseCase = DIContainer.shared.resolve(type: LoginType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let autoLoginUseCase = DIContainer.shared.resolve(type: AutoLoginType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let logoutUseCase = DIContainer.shared.resolve(type: LogoutType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let agreeTermsUseCase = DIContainer.shared.resolve(type: SendAgreeTermsType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let updatePushNoticeUseCase = DIContainer.shared.resolve(type: UpdatePushNoticeType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let updateNicknameUseCase = DIContainer.shared.resolve(type: UpdateNicknameType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let getMemberNameUseCase = DIContainer.shared.resolve(type: GetMemberNameType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let withdrawUseCase = DIContainer.shared.resolve(type: MemberWithdrawType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let fetchAgreeTermsUseCase = DIContainer.shared.resolve(type: FetchAgreeTermsType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let requestWeatherUseCase = DIContainer.shared.resolve(type: RequestWeatherType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let addScenarioUseCase = DIContainer.shared.resolve(type: AddScenarioType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let fetchScenariosUseCase = DIContainer.shared.resolve(type: FetchScenariosType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let deleteScenarioUseCase = DIContainer.shared.resolve(type: DeleteScenarioType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let updateScenarioOrderUseCase = DIContainer.shared.resolve(type: UpdateScenarioOrderType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        DIContainer.shared.register(AgreeItemViewModel(useCase: agreeTermsUseCase))
        DIContainer.shared.register(LoginViewModel(loginUseCase: loginUseCase))
        DIContainer.shared.register(SplashViewModel(useCase: autoLoginUseCase))
        DIContainer.shared.register(HomeViewModel(weatherUseCase: requestWeatherUseCase))
        DIContainer.shared.register(
            ProfileViewModel(
                getMemberNameUseCase: getMemberNameUseCase,
                logoutUseCase: logoutUseCase,
                withdrawUseCase: withdrawUseCase
            )
        )
        DIContainer.shared.register(
            SettingViewModel(
                fetchAgreeTermsUseCase: fetchAgreeTermsUseCase,
                updatePushNoticeUseCase: updatePushNoticeUseCase
            )
        )
        DIContainer.shared.register(NicknameViewModel(useCase: updateNicknameUseCase))
        DIContainer.shared.register(ModifyNicknameViewModel(useCase: updateNicknameUseCase))
        DIContainer.shared.register(AddScenarioViewModel(useCase: addScenarioUseCase))
        DIContainer.shared.register(GetScenariosViewModel(useCase: fetchScenariosUseCase))
        DIContainer.shared.register(DeleteScenarioViewModel(useCase: deleteScenarioUseCase))
        DIContainer.shared.register(UpdateScenarioOrderViewModel(useCase: updateScenarioOrderUseCase))
    }
}
