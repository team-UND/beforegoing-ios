//
//  RequestWeatherUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

import CoreLocation

protocol FetchWeatherType {
    
    func execute(
        date: Date,
        timezone: String,
        location: CLLocation
    ) async throws -> WeatherEntity?
}

struct FetchWeatherUseCase: FetchWeatherType {
    
    private let repository: WeatherInterface
    
    init(repository: WeatherInterface) {
        self.repository = repository
    }
    
    func execute(
        date: Date,
        timezone: String,
        location: CLLocation
    ) async throws -> WeatherEntity? {
        let currentDate = DateUtil.getCurrentDate()
        
        if date == currentDate {
            return try await repository.fetchCurrentWeather(location: location)
        }
        
        if date > currentDate && DateUtil.isWithinThreeDaysFromToday(startDate: currentDate, endDate: date) {
            return try await repository.fetchDayWeather(
                location: location,
                targetDate: date,
                timezone: timezone
            )
        }
        
        return nil
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
