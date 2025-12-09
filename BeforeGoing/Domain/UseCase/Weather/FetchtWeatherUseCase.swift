//
//  RequestWeatherUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

import CoreLocation
import WeatherKit

protocol FetchWeatherType {
    
    func execute(
        date: String,
        timezone: String,
        location: CLLocation
    ) async throws -> WeatherEntity
}

struct FetchWeatherUseCase: FetchWeatherType {
    
    func execute(
        date: String,
        timezone: String,
        location: CLLocation
    ) async throws -> WeatherEntity {
        let result = try await WeatherService.shared.weather(for: location)
        
        let condition = result.currentWeather.condition
        let uv = result.currentWeather.uvIndex
        
        return .init(weatherCondition: condition, uvIndex: uv)
    }
}

struct MockFetchWeatherUseCase: FetchWeatherType {
    
    func execute(
        date: String,
        timezone: String,
        location: CLLocation
    ) async throws -> WeatherEntity {
        return .stub()
    }
}
