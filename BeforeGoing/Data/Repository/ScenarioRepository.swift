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
    private let updateScenarioRequestMapper: UpdateScenarioRequestMapper
    private let updateScenarioOrderRequestMapper: UpdateScenarioOrderRequestMapper
    
    init(
        networkService: NetworkService,
        keyChainService: KeyChainService,
        addScenarioRequestMapper: AddScenarioRequestMapper,
        updateScenarioRequestMapper: UpdateScenarioRequestMapper,
        updateScenarioOrderRequestMapper: UpdateScenarioOrderRequestMapper
    ) {
        self.networkService = networkService
        self.keyChainService = keyChainService
        self.addScenarioRequestMapper = addScenarioRequestMapper
        self.updateScenarioRequestMapper = updateScenarioRequestMapper
        self.updateScenarioOrderRequestMapper = updateScenarioOrderRequestMapper
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
    
    func fetchScenario(scenarioID: Int) async throws -> ScenarioWithNotificationEntity {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return .stub()
        }
        
        let result = try await networkService.request(
            endPoint: ScenarioAPI.getScenario(
                accessToken: accessToken,
                scenarioID: scenarioID
            ),
            responseType: GetScenarioResponseDTO.self
        )
        return result.toEntity()
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
    
    func deleteScenario(scenarioID: Int) async throws {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return
        }
        
        try await networkService.request(
            endPoint: ScenarioAPI.deleteScenario(
                accessToken: accessToken,
                scenarioID: scenarioID
            )
        )
    }
    
    func updateScenario(
        scenarioID: Int,
        scenarioName: String,
        memo: String,
        missions: [(missionID: Int?, content: String)],
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
        
        let requestDTO = updateScenarioRequestMapper.map(
            (
                scenarioName: scenarioName,
                memo: memo,
                missions: missions,
                isNotificationActive: isNotificationActive,
                noticeMethodType: noticeMethodType,
                daysOfWeekOrdinal: daysOfWeekOrdinal,
                startHour: startHour,
                startMinute: startMinute
            )
        )
        let result = try await networkService.request(
            endPoint: decideEndPoint(
                dto: requestDTO,
                accessToken: accessToken,
                scenarioID: scenarioID
            ),
            responseType: [ScenarioResponseDTO].self
        )
        return result.first?.toEntity() ?? .stub()
    }
    
    func updateScenarioOrder(
        scenarioID: Int,
        prevOrder: Int?,
        nextOrder: Int?
    ) async throws -> NewScenarioOrderEntity {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return .stub()
        }
        
        let dto = updateScenarioOrderRequestMapper.map((prevOrder, nextOrder))
        
        let result = try await networkService
            .request(
                endPoint: ScenarioAPI.updateOrder(
                    accessToken: accessToken,
                    scenarioID: scenarioID,
                    dto: dto
                ),
                responseType: UpdateScenarioOrderResponseDTO.self
            )
        return result.toEntity()
    }
    
    func fetchNotifications() async throws -> NotificationsEntity {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return .stub()
        }
        
        let result = try await networkService.request(
            endPoint: ScenarioAPI.getNotifications(accessToken: accessToken),
            responseType: NotificationsDTO.self
        )
        return result.toEntity()
    }
    
    private func decideEndPoint(dto: AddScenarioRequestDTO, accessToken: String) -> EndPoint {
        switch dto {
        case .withNotification(let withNotificationAddScenarioRequestDTO):
            return ScenarioAPI.addScnearioWithNotification(
                accessToken: accessToken,
                dto: withNotificationAddScenarioRequestDTO
            )
        case .withoutNotification(let withoutNotificationAddScenarioRequestDTO):
            return ScenarioAPI.addScnearioWithoutNotification(
                accessToken: accessToken,
                dto: withoutNotificationAddScenarioRequestDTO
            )
        }
    }
    
    private func decideEndPoint(
        dto: UpdateScenarioRequestDTO,
        accessToken: String,
        scenarioID: Int
    ) -> EndPoint {
        switch dto {
        case .withNotification(let withNotificationUpdateScenarioRequestDTO):
            return ScenarioAPI.updateScenarioWithNotification(
                accessToken: accessToken,
                scenarioID: scenarioID,
                dto: withNotificationUpdateScenarioRequestDTO
            )
        case .withoutNotification(let withoutNotificationAddScenarioRequestDTO):
            return ScenarioAPI.updateScenarioWithoutNotification(
                accessToken: accessToken,
                scenarioID: scenarioID,
                dto: withoutNotificationAddScenarioRequestDTO
            )
        }
    }
}
