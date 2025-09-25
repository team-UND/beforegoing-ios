//
//  WeatherRepository.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

struct WeatherRepository: WeatherInterface {
    
    private let networkService: NetworkService
    private let keyChainServcie: KeyChainService
    private let weatherResponseMapper: WeatherResponseMapper
    
    init(
        networkService: NetworkService,
        keyChainServcie: KeyChainService,
        weatherResponseMapper: WeatherResponseMapper
    ) {
        self.networkService = networkService
        self.keyChainServcie = keyChainServcie
        self.weatherResponseMapper = weatherResponseMapper
    }
    
    func requestWeather(
        date: String,
        timezone: String,
        weatherRequestDTO: WeatherRequestDTO
    ) async throws -> WeatherEntity {
        guard let accessToken = keyChainServcie.load(key: .accessToken) else {
            return .stub()
        }
        
        let result = try await networkService
            .request(
                endPoint: WeatherAPI.weather(
                    accessToken: accessToken,
                    date: date,
                    timezone: timezone,
                    dto: weatherRequestDTO
                ),
                responseType: WeatherResponseDTO.self
            )
        let mappedResult = weatherResponseMapper.map(result)
        
        return .init(
            weather: mappedResult.weather,
            fineDust: mappedResult.fineDust,
            uv: mappedResult.uv
        )
    }
}
