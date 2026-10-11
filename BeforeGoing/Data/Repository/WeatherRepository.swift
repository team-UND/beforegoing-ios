//
//  WeatherRepository.swift
//  BeforeGoing
//
//  Created by 더스틴 on 10/11/26.
//

import CoreLocation
import WeatherKit

final class WeatherRepository: WeatherInterface {
    
    func fetchCurrentWeather(location: CLLocation) async throws -> WeatherEntity? {
        let currentWeather = try await WeatherService.shared.weather(for: location, including: .current)
        
        guard let condition = WeatherKind(currentWeather.condition) else {
            return nil
        }
        
        let uv = UVLevel(currentWeather.uvIndex.category)
        
        return .init(weatherCondition: condition, uvIndex: uv)
    }
    
    func fetchDayWeather(
        location: CLLocation,
        targetDate: Date,
        timezone: String
    ) async throws -> WeatherEntity? {
        let dailyWeather = try await WeatherService.shared.weather(for: location, including: .daily)
        
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: timezone) ?? .current
        
        guard let targetDayWeather = dailyWeather.forecast.first(where: {
            calendar.isDate($0.date, inSameDayAs: targetDate)
        }) else {
            return nil
        }
        
        guard let condition = WeatherKind(targetDayWeather.condition) else {
            return nil
        }
        
        let uv = UVLevel(targetDayWeather.uvIndex.category)
        
        return .init(weatherCondition: condition, uvIndex: uv)
    }
}
