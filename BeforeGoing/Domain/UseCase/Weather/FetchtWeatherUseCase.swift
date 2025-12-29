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
            return try await fetchDayWeather(location: location, targetDate: date)
        }
        
        return nil
    }
    
    private func fetchCurrentWeather(location: CLLocation) async throws -> WeatherEntity {
        let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
        let condition = currentWeather.condition
        let uv = currentWeather.uvIndex
        
        return .init(weatherCondition: condition, uvIndex: uv)
    }
    
    private func fetchDayWeather(
        location: CLLocation,
        targetDate: Date
    ) async throws -> WeatherEntity? {
        let dailyWeather = try await WeatherService.shared.weather(for: location, including: .daily)
        
        let calendar = Calendar.current
        
        guard let targetDayWeather = dailyWeather.forecast.first(where: {
            calendar.isDate($0.date, inSameDayAs: targetDate)
        }) else {
            return nil
        }
        
        let condition = targetDayWeather.condition
        let uv = targetDayWeather.uvIndex
        
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
