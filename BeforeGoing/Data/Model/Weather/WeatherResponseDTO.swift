//
//  WeatherResponseDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

struct WeatherResponseDTO: Decodable {
    let weather: String
    let fineDust: String
    let uv: String
}
