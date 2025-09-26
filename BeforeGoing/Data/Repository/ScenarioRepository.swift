//
//  ScenarioRepository.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

struct ScenarioRepository: ScenarioInterface {
    
    private let networkService: NetworkService
    private let keyChainService: KeyChainService
    private let addScenarioRequestMapper: AddScenarioRequestMapper
    
    init(
        networkService: NetworkService,
        keyChainService: KeyChainService,
        addScenarioRequestMapper: AddScenarioRequestMapper
    ) {
        self.networkService = networkService
        self.keyChainService = keyChainService
        self.addScenarioRequestMapper = addScenarioRequestMapper
    }
    
    func addScenario(
        scenarioName: String,
        memo: String,
        basicMissions: [String],
        isNotificationActive: Bool,
        noticeMethodType: String?,
        daysOfWeekOrdinal: [Int]?,
        startHour: Int?,
        startMinute: Int?
    ) async throws -> ScenarioEntity {
        
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return .stub()
        }
        
        let requestDTO = addScenarioRequestMapper.map(
            (
                scenarioName: scenarioName,
                memo: memo,
                basicMissions: basicMissions,
                isNotificationActive: isNotificationActive,
                noticeMethodType: noticeMethodType,
                daysOfWeekOrdinal: daysOfWeekOrdinal,
                startHour: startHour,
                startMinute: startMinute
            )
        )
        let endPoint = decideEndPoint(
            dto: requestDTO,
            accessToken: accessToken
        )
        let result = try await networkService.request(
            endPoint: endPoint,
            responseType: [ScenarioResponseDTO].self
        )
        return result.first?.toEntity() ?? .stub()
    }
    
    func fetchScenarios() async throws -> [ScenarioEntity] {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return [.stub()]
        }
        
        let result = try await networkService.request(
            endPoint: ScenarioAPI.getScenarios(accessToken: accessToken),
            responseType: [ScenarioResponseDTO].self
        )
        return result.map { $0.toEntity() }
    }
    
    private func decideEndPoint(dto: AddScenarioRequestDTO, accessToken: String) -> EndPoint {
        switch dto {
        case .withNotification(let withNotificationAddScenarioRequestDTO):
            return ScenarioAPI.addScnearioWithNotification(
                accessToken: accessToken,
                dto: withNotificationAddScenarioRequestDTO
            )
        case .withoutNotification(let WithoutNotificationAddScenarioRequestDTO):
            return ScenarioAPI.addScnearioWithoutNotification(
                accessToken: accessToken,
                dto: WithoutNotificationAddScenarioRequestDTO
            )
        }
    }
}
