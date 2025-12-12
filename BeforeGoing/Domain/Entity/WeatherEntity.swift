//
//  WeatherEntity.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

import Foundation

import WeatherKit

struct WeatherEntity {
        
    let weatherCondition: WeatherCondition
    let uvIndex: UVProtocol
}

extension WeatherEntity {
    
    struct MockUVIndex: UVProtocol {
        var description: String = "눈"
        var supply: String? = "우산"
    }
    
    static func stub() -> Self {
        .init(
            weatherCondition: .blizzard,
            uvIndex: MockUVIndex()
        )
    }
}
