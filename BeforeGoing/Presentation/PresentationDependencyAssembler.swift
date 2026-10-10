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
        
        guard let requestWeatherUseCase = DIContainer.shared.resolve(type: FetchWeatherType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let addScenarioUseCase = DIContainer.shared.resolve(type: AddScenarioType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let fetchSingleScenarioUsecase = DIContainer.shared.resolve(type: FetchSingleScenarioType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let fetchScenariosUseCase = DIContainer.shared.resolve(type: FetchScenariosType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let fetchNotificationsUseCase = DIContainer.shared.resolve(type: FetchNotificationsType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let deleteScenarioUseCase = DIContainer.shared.resolve(type: DeleteScenarioType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let updateScenarioUseCase = DIContainer.shared.resolve(type: UpdateScenarioType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let updateScenarioOrderUseCase = DIContainer.shared.resolve(type: UpdateScenarioOrderType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let getMissionUseCase = DIContainer.shared.resolve(type: FetchMissionsType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let checkMissionUseCase = DIContainer.shared.resolve(type: CheckMissionType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let addTodayMissionUseCase = DIContainer.shared.resolve(type: AddTodayMissionType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let deleteTodayMissionUseCase = DIContainer.shared.resolve(type: DeleteTodayMissionType.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        DIContainer.shared.register(
            LoginViewModel(loginUseCase: loginUseCase)
        )
        DIContainer.shared.register(
            HomeViewModel(
                getMemberNameUseCase: getMemberNameUseCase,
                weatherUseCase: requestWeatherUseCase,
                getMissionsUseCase: getMissionUseCase,
                checkMissionUseCase: checkMissionUseCase,
                addTodayMissionUseCase: addTodayMissionUseCase,
                deleteTodayMissionUseCase: deleteTodayMissionUseCase
            )
        )
        DIContainer.shared.register(
            ProfileViewModel(
                getMemberNameUseCase: getMemberNameUseCase,
                withdrawUseCase: withdrawUseCase
            )
        )
        DIContainer.shared.register(
            SettingViewModel(
                fetchAgreeTermsUseCase: fetchAgreeTermsUseCase,
                updatePushNoticeUseCase: updatePushNoticeUseCase
            )
        )
        DIContainer.shared.register(
            NicknameViewModel(
                useCase: updateNicknameUseCase
            )
        )
        DIContainer.shared.register(
            ModifyNicknameViewModel(
                useCase: updateNicknameUseCase
            )
        )
        DIContainer.shared.register(AddScenarioViewModel(useCase: addScenarioUseCase))
        DIContainer.shared.register(
            GetAllScenariosViewModel(fetchScenariosUseCase: fetchScenariosUseCase)
        )
        DIContainer.shared.register(
            GetScenariosViewModel(
                fetchScenariosUseCase: fetchScenariosUseCase,
                fetchNotificationsUseCase: fetchNotificationsUseCase
            )
        )
        DIContainer.shared.register(
            DeleteScenarioViewModel(
                useCase: deleteScenarioUseCase
            )
        )
        DIContainer.shared.register(
            UpdateScenarioViewModel(
                useCase: updateScenarioUseCase
            )
        )
        DIContainer.shared.register(
            UpdateScenarioOrderViewModel(
                useCase: updateScenarioOrderUseCase
            )
        )
        DIContainer.shared.register(
            GetSingleScenarioViewModel(
                useCase: fetchSingleScenarioUsecase
            )
        )
        DIContainer.shared.register(ManageScenarioViewModel())
        DIContainer.shared.register(AgreeItemViewModel(sendAgreeUseCase: agreeTermsUseCase))
    }
}
