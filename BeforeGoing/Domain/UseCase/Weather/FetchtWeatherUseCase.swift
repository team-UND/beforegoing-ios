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
        date: Date,
        timezone: String,
        location: CLLocation
    ) async throws -> WeatherEntity?
}

struct FetchWeatherUseCase: FetchWeatherType {
    
    func execute(
        date: Date,
        timezone: String,
        location: CLLocation
    ) async throws -> WeatherEntity? {
        let currentDate = DateUtil.getCurrentDate()
        
        if date == currentDate {
            return try await fetchCurrentWeather(location: location)
        }
        
        if date > currentDate && DateUtil.isWithinThreeDaysFromToday(startDate: currentDate, endDate: date) {
            return try await fetchDayWeather(location: location)
        }
        
        return nil
    }
    
    private func fetchCurrentWeather(location: CLLocation) async throws -> WeatherEntity {
        let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
        let condition = currentWeather.condition
        let uv = currentWeather.uvIndex
        
        return .init(weatherCondition: condition, uvIndex: uv)
    }
    
    private func fetchDayWeather(location: CLLocation) async throws -> WeatherEntity? {
        let dailyWeather = try await WeatherService.shared.weather(for: location, including: .daily)
        guard let dailyFirstWeather = dailyWeather.forecast.first else {
            return nil
        }
           
        let condition = dailyFirstWeather.condition
        let uv = dailyFirstWeather.uvIndex
        
        return .init(weatherCondition: condition, uvIndex: uv)
    }
}

struct MockFetchWeatherUseCase: FetchWeatherType {
    
    func execute(
        date: Date,
        timezone: String,
        location: CLLocation
    ) async throws -> WeatherEntity? {
        return .stub()
    }
}
