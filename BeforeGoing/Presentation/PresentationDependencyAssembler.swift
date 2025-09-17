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
        
        guard let kakaoLoginUseCase: KakaoLoginUseCase = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let autoLoginUseCase: AutoLoginUseCase = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let logoutUseCase: LogoutUseCase = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let agreeTermsUseCase: AgreeTermsUseCase = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let updatePushNoticeUseCase: UpdatePushNoticeUseCase = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        guard let updateNicknameUseCase: UpdateNicknameUseCase = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            fatalError()
        }
        
        DIContainer.shared.register(AgreeItemViewModel(useCase: agreeTermsUseCase))
        DIContainer.shared.register(LoginViewModel(kakaoLoginUseCase: kakaoLoginUseCase))
        DIContainer.shared.register(SplashViewModel(useCase: autoLoginUseCase))
        DIContainer.shared.register(ProfileViewModel(logoutUseCase: logoutUseCase))
        DIContainer.shared.register(SettingViewModel(useCase: updatePushNoticeUseCase))
        DIContainer.shared.register(NicknameViewModel(useCase: updateNicknameUseCase))
    }
}
