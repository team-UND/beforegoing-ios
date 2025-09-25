//
//  RequestWeatherUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

protocol RequestWeatherType {
    
    func execute(
        date: String,
        timezone: String,
        latitude: Float,
        longitude: Float
    ) async throws -> WeatherEntity
}

struct RequestWeatherUseCase: RequestWeatherType {
    
    private let repository: WeatherInterface
    
    init(repository: WeatherInterface) {
        self.repository = repository
    }
    
    func execute(
        date: String,
        timezone: String,
        latitude: Float,
        longitude: Float
    ) async throws -> WeatherEntity {
        let result = try await repository.requestWeather(
            date: date,
            timezone: timezone,
            weatherRequestDTO: .init(latitude: latitude, longitude: longitude)
        )
        return result
    }
}

struct MockRequestWeatherUseCase: RequestWeatherType {
    
    func execute(
        date: String,
        timezone: String,
        latitude: Float,
        longitude: Float
    ) async throws -> WeatherEntity {
        return .stub()
    }
}
