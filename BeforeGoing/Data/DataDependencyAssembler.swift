//
//  DataDependencyResembler.swift
//  BeforeGoing
//
//  Created by APPLE on 9/14/25.
//

struct DataDependencyAssembler: DependencyAssembler {
    
    private let networkService = NetworkService.shared
    private let keyChainService = KeyChainService()
    private let tokenReissuer: TokenReissuer
    private let userDefaultsService = UserDefaultsService()
    private let nonceRequestMapper = NonceRequestMapper()
    private let loginRequestMapper = LoginRequestMapper()
    private let termsRequestMapper = TermsRequestMapper()
    private let updateTermRequestMapper = UpdateTermRequestMapper()
    private let updateNicknameRequestMapper = UpdateNicknameRequestMapper()
    private let weatherResponseMapper = WeatherResponseMapper()
    private let addScenarioRequestMapper = AddScenarioRequestMapper()
    private let updateScenarioRequestMapper = UpdateScenarioRequestMapper()
    private let updateScenarioOrderRequestMapper = UpdateScenarioOrderRequestMapper()
    private let tokenValidator = TokenValidator()
    
    init() {
        self.tokenReissuer = TokenReissuer(keyChainService: keyChainService)
    }
    
    func assemble() {
        DIContainer.shared.register(nonceRequestMapper)
        DIContainer.shared.register(loginRequestMapper)
        DIContainer.shared.register(termsRequestMapper)
        DIContainer.shared.register(updateTermRequestMapper)
        DIContainer.shared.register(updateScenarioRequestMapper)
        DIContainer.shared.register(updateNicknameRequestMapper)
        DIContainer.shared.register(weatherResponseMapper)
        
        DIContainer.shared.register(type: AuthInterface.self) { _ in
            AuthRepository(
                networkService: networkService,
                tokenReissuer: tokenReissuer,
                keyChainService: keyChainService,
                userDefaultsService: userDefaultsService,
                nonceRequestMapper: nonceRequestMapper,
                loginRequestMapper: loginRequestMapper,
                tokenValidator: tokenValidator
            )
        }
        DIContainer.shared.register(type: TermsInterface.self) { _ in
            TermsRepository(
                networkService: networkService,
                keyChainService: keyChainService,
                userDefaultsService: userDefaultsService,
                termsRequestMapper: termsRequestMapper,
                updateTermRequestMapper: updateTermRequestMapper
            )
        }
        DIContainer.shared.register(type: MemberInterface.self) { _ in
            MemberRepository(
                networkService: networkService,
                keyChainService: keyChainService,
                userDefaultsService: userDefaultsService,
                updateNicknameRequestMapper: updateNicknameRequestMapper
            )
        }
        DIContainer.shared.register(type: WeatherInterface.self) { _ in
            WeatherRepository(
                networkService: networkService,
                keyChainServcie: keyChainService,
                weatherResponseMapper: weatherResponseMapper
            )
        }
        DIContainer.shared.register(type: ScenarioInterface.self) { _ in
            ScenarioRepository(
                networkService: networkService,
                keyChainService: keyChainService,
                addScenarioRequestMapper: addScenarioRequestMapper,
                updateScenarioRequestMapper: updateScenarioRequestMapper,
                updateScenarioOrderRequestMapper: updateScenarioOrderRequestMapper
            )
        }
        DIContainer.shared.register(type: MissionInterface.self) { _ in
            MissionRepository(
                networkService: networkService,
                keyChainService: keyChainService
            )
        }
    }
}
