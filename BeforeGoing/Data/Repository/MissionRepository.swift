//
//  MissionRepository.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

struct MissionRepository: MissionInterface {
    
    private let networkService: NetworkService
    private let keyChainService: KeyChainService
    
    init(
        networkService: NetworkService,
        keyChainService: KeyChainService
    ) {
        self.networkService = networkService
        self.keyChainService = keyChainService
    }
    
    func fetchMissions(scenarioID: Int, date: String) async throws -> MissionsEntity {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return .stub()
        }
        
        let result = try await networkService.request(
            endPoint: MissionAPI.getMissions(
                accessToken: accessToken,
                scenarioID: scenarioID,
                date: date
            ),
            responseType: MissionResponseDTO.self
        )
        return result.toEntity()
    }
}
