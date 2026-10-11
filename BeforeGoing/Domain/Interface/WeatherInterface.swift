//
//  WeatherInterface.swift
//  BeforeGoing
//
//  Created by 더스틴 on 10/11/26.
//

import CoreLocation

protocol WeatherInterface {
    func fetchCurrentWeather(location: CLLocation) async throws -> WeatherEntity?
    func fetchDayWeather(
        location: CLLocation,
        targetDate: Date,
        timezone: String
    ) async throws -> WeatherEntity?
}
