//
//  DomainDependencyResembler.swift
//  BeforeGoing
//
//  Created by APPLE on 9/14/25.
//

final class DomainDependencyAssembler: DependencyAssembler {
    
    private let dataDependencyAssembler: DataDependencyAssembler
    
    init(preAssembler: DataDependencyAssembler) {
        self.dataDependencyAssembler = preAssembler
    }
    
    func assemble() {
        dataDependencyAssembler.assemble()
        
        guard let nonceRequestMapper: NonceRequestMapper = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            return
        }
        
        guard let loginRequestMapper: LoginRequestMapper = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            return
        }
        
        guard let authrepository: AuthRepository = DIContainer.shared.resolve() else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            return
        }
        
        DIContainer.shared.register(AutoLoginUseCase(repository: authrepository))
        DIContainer.shared.register(KakaoLoginUseCase(
            nonceRequestMapper: nonceRequestMapper,
            loginRequestMapper: loginRequestMapper,
            repository: authrepository
        ))
        DIContainer.shared.register(LogoutUseCase(repository: authrepository))
    }
}
