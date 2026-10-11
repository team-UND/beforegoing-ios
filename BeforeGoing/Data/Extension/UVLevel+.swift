//
//  UVLevel+.swift
//  BeforeGoing
//
//  Created by 더스틴 on 10/11/26.
//

import WeatherKit

extension UVLevel {
    
    init(_ category: UVIndex.ExposureCategory) {
        switch category {
        case .low:
            self = .low
        case .moderate:
            self = .moderate
        case .high:
            self = .high
        case .veryHigh:
            self = .veryHigh
        case .extreme:
            self = .extreme
        }
    }
}
