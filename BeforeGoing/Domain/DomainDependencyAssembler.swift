//
//  DomainDependencyResembler.swift
//  BeforeGoing
//
//  Created by APPLE on 9/14/25.
//

import Foundation

final class DomainDependencyAssembler: DependencyAssembler {
    
    private let dataDependencyAssembler: DataDependencyAssembler
    
    init(preAssembler: DataDependencyAssembler) {
        self.dataDependencyAssembler = preAssembler
    }
    
    func assemble() {
        dataDependencyAssembler.assemble()
        
        guard let authrepository = DIContainer.shared.resolve(type: AuthInterface.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            return
        }
        
        guard let termsRepository = DIContainer.shared.resolve(type: TermsInterface.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            return
        }
        
        guard let memberRepository = DIContainer.shared.resolve(type: MemberInterface.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            return
        }
        
        let isUITestWithMock = ProcessInfo.processInfo.environment["USE_MOCK_AUTOLOGIN"] == "true"

        if isUITestWithMock {
            DIContainer.shared.register(type: AutoLoginType.self) { _ in
                return MockAutoLoginUseCase()
            }
        } else {
            DIContainer.shared.register(type: AutoLoginType.self) { _ in
                return AutoLoginUseCase(repository: authrepository)
            }
        }
        DIContainer.shared.register(KakaoLoginUseCase(repository: authrepository))
        DIContainer.shared.register(LogoutUseCase(repository: authrepository))
        
        DIContainer.shared.register(FetchAgreeTermsUseCase(repository: termsRepository))
        DIContainer.shared.register(SendAgreeTermsUseCase(repository: termsRepository))
        DIContainer.shared.register(UpdatePushNoticeUseCase(repository: termsRepository))
        
        DIContainer.shared.register(UpdateNicknameUseCase(repository: memberRepository))
        DIContainer.shared.register(GetMemberNameUseCase(repository: memberRepository))
        DIContainer.shared.register(MemberWithdrawUseCase(repository: memberRepository))
    }
}
