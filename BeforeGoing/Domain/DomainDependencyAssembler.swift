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
        let isUITestWithMock = ProcessInfo.processInfo.environment["USE_MOCK"] == "true"
        
        if isUITestWithMock {
            DIContainer.shared.register(type: AutoLoginType.self) { _ in MockAutoLoginUseCase() }
            DIContainer.shared.register(type: LoginType.self) { _ in MockLoginUseCase() }
            DIContainer.shared.register(type: LogoutType.self) { _ in MockLogoutUseCase() }
            
            DIContainer.shared.register(type: FetchAgreeTermsType.self) { _ in MockFetchAgreeTermsUseCase() }
            DIContainer.shared.register(type: SendAgreeTermsType.self) { _ in MockSendAgreeTermsUseCase() }
            DIContainer.shared.register(type: UpdatePushNoticeType.self) { _ in MockUpdatePushNoticeUseCase() }
            
            DIContainer.shared.register(type: UpdateNicknameType.self) { _ in MockUpdateNicknameUseCase() }
            DIContainer.shared.register(type: GetMemberNameType.self) { _ in MockGetMemberNameUseCase() }
            DIContainer.shared.register(type: MemberWithdrawType.self) { _ in MockMemberWithdrawUseCase() }
            
            DIContainer.shared.register(type: FetchWeatherType.self) { _ in MockFetchWeatherUseCase() }
            
            DIContainer.shared.register(type: AddScenarioType.self) { _ in MockAddScenarioUseCase() }
            DIContainer.shared.register(type: FetchScenariosType.self) { _ in MockFetchScenariosUseCase() }
            DIContainer.shared.register(type: DeleteScenarioType.self) { _ in MockDeleteScenarioUseCase() }
            DIContainer.shared.register(type: UpdateScenarioType.self) { _ in  MockUpdateScenarioUseCase() }
            DIContainer.shared.register(type: UpdateScenarioOrderType.self) { _ in MockUpdateScenarioOrderUseCase() }
            DIContainer.shared.register(type: FetchSingleScenarioType.self) { _ in MockFetchSingleScenarioUseCase() }
            
            DIContainer.shared.register(type: FetchMissionsType.self) { _ in MockFetchMissionsUseCase() }
            DIContainer.shared.register(type: CheckMissionType.self) { _ in MockCheckMissionUseCase() }
            DIContainer.shared.register(type: AddTodayMissionType.self) { _ in MockAddTodayMissionUseCase() }
            DIContainer.shared.register(type: DeleteTodayMissionType.self) { _ in MockDeleteTodayMissionUseCase() }
            
            return
        }
        
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
        
        guard let scenarioRepository = DIContainer.shared.resolve(type: ScenarioInterface.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            return
        }
        
        guard let missionRepository = DIContainer.shared.resolve(type: MissionInterface.self) else {
            BeforeGoingLogger.error(BeforeGoingError.diContainerError)
            return
        }
        
        DIContainer.shared.register(type: AutoLoginType.self) { _ in
            AutoLoginUseCase(repository: authrepository)
        }
        DIContainer.shared.register(type: LoginType.self) { _ in
            LoginUseCase(repository: authrepository)
        }
        DIContainer.shared.register(type: GetLastLoginType.self) { _ in
            GetLastLoginUseCase(repository: authrepository)
        }
        DIContainer.shared.register(type: LogoutType.self) { _ in
            return LogoutUseCase(repository: authrepository)
        }
        
        DIContainer.shared.register(type: FetchAgreeTermsType.self) { _ in
            return FetchAgreeTermsUseCase(repository: termsRepository)
        }
        DIContainer.shared.register(type: SendAgreeTermsType.self) { _ in
            return SendAgreeTermsUseCase(repository: termsRepository)
        }
        DIContainer.shared.register(type: IsAppleLoginType.self) { _ in
            return IsAppleLoginedUseCase(repository: memberRepository)
        }
        DIContainer.shared.register(type: UpdatePushNoticeType.self) { _ in
            return UpdatePushNoticeUseCase(repository: termsRepository)
        }
        
        DIContainer.shared.register(type: UpdateNicknameType.self) { _ in
            return UpdateNicknameUseCase(repository: memberRepository)
        }
        DIContainer.shared.register(type: GetMemberNameType.self) { _ in
            return GetMemberNameUseCase(repository: memberRepository)
        }
        DIContainer.shared.register(type: MemberWithdrawType.self) { _ in
            return MemberWithdrawUseCase(repository: memberRepository)
        }
        
        DIContainer.shared.register(type: FetchWeatherType.self) { _ in
            return FetchWeatherUseCase()
        }
        
        DIContainer.shared.register(type: AddScenarioType.self) { _ in
            return AddScenarioUseCase(repository: scenarioRepository)
        }
        DIContainer.shared.register(type: FetchScenariosType.self) { _ in
            return FetchScenariosUseCase(repository: scenarioRepository)
        }
        DIContainer.shared.register(type: FetchNotificationsType.self) { _ in
            return FetchNotificationsUseCase(repository: scenarioRepository)
        }
        DIContainer.shared.register(type: DeleteScenarioType.self) { _ in
            return DeleteScenarioUseCase(repository: scenarioRepository)
        }
        DIContainer.shared.register(type: UpdateScenarioType.self) { _ in
            return UpdateScenarioUseCase(repository: scenarioRepository)
        }
        DIContainer.shared.register(type: UpdateScenarioOrderType.self) { _ in
            return UpdateScenarioOrderUseCase(repository: scenarioRepository)
        }
        DIContainer.shared.register(type: FetchSingleScenarioType.self) { _ in
            return FetchSingleScenarioUseCase(repository: scenarioRepository)
        }
        
        DIContainer.shared.register(type: FetchMissionsType.self) { _ in
            return FetchMissionsUseCase(repository: missionRepository)
        }
        DIContainer.shared.register(type: CheckMissionType.self) { _ in
            return CheckMissionUseCase(repository: missionRepository)
        }
        DIContainer.shared.register(type: AddTodayMissionType.self) { _ in
            return AddTodayMissionUseCase(repository: missionRepository)
        }
        DIContainer.shared.register(type: DeleteTodayMissionType.self) { _ in
            return DeleteTodayMissionUseCase(repository: missionRepository)
        }
    }
}
