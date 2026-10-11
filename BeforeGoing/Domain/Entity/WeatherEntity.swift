//
//  WeatherEntity.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

import Foundation

struct WeatherEntity {
        
    let weatherCondition: WeatherKind
    let uvIndex: UVLevel
}

extension WeatherEntity {
    
    static func stub() -> Self {
        .init(
            weatherCondition: .blizzard,
            uvIndex: .high
        )
    }
}
