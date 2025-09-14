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
    
    func resemble() {
        domainDependencyAssembler.resemble()
        
        guard let kakaoLoginUseCase: KakaoLoginUseCase = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            return
        }
        
        guard let autoLoginUseCase: AutoLoginUseCase = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            return
        }
        
        guard let logoutUseCase: LogoutUseCase = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            return
        }
        
        DIContainer.shared.register(AgreeItemViewModel())
        DIContainer.shared.register(LoginViewModel(kakaoLoginUseCase: kakaoLoginUseCase))
        DIContainer.shared.register(SplashViewModel(useCase: autoLoginUseCase))
        DIContainer.shared.register(ProfileViewModel(logoutUseCase: logoutUseCase))
    }
}
