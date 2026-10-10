//
//  DataDependencyResembler.swift
//  BeforeGoing
//
//  Created by APPLE on 9/14/25.
//

struct DataDependencyAssembler: DependencyAssembler {
    
    private let keyChainService = KeyChainService()
    private let userDefaultsService = UserDefaultsService()
    
    func assemble() {
        DIContainer.shared.register(type: AuthInterface.self) { _ in
            AuthStorage(
                userDefaultsService: userDefaultsService,
                context: CoreDataStack.shared.context,
                memberStorage: MemberStorage(
                    userDefaultsService: userDefaultsService,
                    context: CoreDataStack.shared.context
                )
            )
        }
        DIContainer.shared.register(type: TermsInterface.self) { _ in
            TermsStorage(
                userDefaultsService: userDefaultsService,
                context: CoreDataStack.shared.context
            )
        }
        DIContainer.shared.register(type: MemberInterface.self) { _ in
            MemberStorage(
                userDefaultsService: userDefaultsService,
                context: CoreDataStack.shared.context
            )
        }
        DIContainer.shared.register(type: ScenarioInterface.self) { _ in
            ScenarioStorage(
                userDefaultService: userDefaultsService,
                context: CoreDataStack.shared.context
            )
        }
        DIContainer.shared.register(type: MissionInterface.self) { _ in
            MissionStorage(
                userDefaultsService: userDefaultsService,
                context: CoreDataStack.shared.context
            )
        }
    }
}
