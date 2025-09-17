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
    private let nonceRequestMapper = NonceRequestMapper()
    private let loginRequestMapper = LoginRequestMapper()
    private let termsRequestMapper = TermsRequestMapper()
    private let updateTermRequestMapper = UpdateTermRequestMapper()
    
    init() {
        self.tokenReissuer = TokenReissuer(keyChainService: keyChainService)
    }
    
    func assemble() {
        DIContainer.shared.register(nonceRequestMapper)
        DIContainer.shared.register(loginRequestMapper)
        DIContainer.shared.register(
            AuthRepository(
                networkService: networkService,
                tokenReissuer: tokenReissuer,
                keyChainService: keyChainService,
                nonceRequestMapper: nonceRequestMapper,
                loginRequestMapper: loginRequestMapper
            )
        )
        DIContainer.shared.register(
            TermsRepository(
                networkService: networkService,
                keyChainService: keyChainService,
                termsRequestMapper: termsRequestMapper,
                updateTermRequestMapper: updateTermRequestMapper
            )
        )
    }
}
