//
//  WeatherInterface.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

protocol WeatherInterface {
    func requestWeather(
        date: String,
        timezone: String,
        weatherRequestDTO: WeatherRequestDTO
    ) async throws -> WeatherEntity
}
