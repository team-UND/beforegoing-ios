//
//  MissionRepository.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

struct MissionRepository: MissionInterface {
    
    private let networkService: NetworkService
    private let keyChainService: KeyChainService
    private let addTodayMissionRequestMapper: AddTodayMissionRequestMapper
    
    init(
        networkService: NetworkService,
        keyChainService: KeyChainService,
        addTodayMissionRequestMapper: AddTodayMissionRequestMapper
    ) {
        self.networkService = networkService
        self.keyChainService = keyChainService
        self.addTodayMissionRequestMapper = addTodayMissionRequestMapper
    }
    
    func fetchMissions(
        scenarioID: Int,
        date: String
    ) async throws -> MissionsEntity {
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
    
    func checkMission(
        missionID: Int,
        date: String,
        isChecked: Bool
    ) async throws {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return
        }
        
        try await networkService.request(
            endPoint: MissionAPI.checkMission(
                accessToken: accessToken,
                missionID: missionID,
                date: date,
                isChecked: isChecked
            )
        )
    }
    
    func addTodayMission(
        scenarioID: Int,
        date: String,
        content: String
    ) async throws -> TodayMissionEntity {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return .stub()
        }
        
        let requestDTO = addTodayMissionRequestMapper.map(content)
        let result = try await networkService.request(
            endPoint: MissionAPI.addTodayMission(
                accessToken: accessToken,
                scenarioID: scenarioID,
                date: date,
                dto: requestDTO
            ),
            responseType: TodayMissionDTO.self
        )
        return result.toEntity()
    }
    
    func deleteTodayMission(missionID: Int) async throws {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return
        }
        
        let _ = try await networkService.request(
            endPoint: MissionAPI.deleteTodayMission(
                accessToken: accessToken,
                missionID: missionID
            )
        )
    }
}
