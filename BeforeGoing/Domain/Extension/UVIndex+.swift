//
//  UVIndex+.swift
//  BeforeGoing
//
//  Created by APPLE on 12/9/25.
//

import WeatherKit

protocol UVProtocol {
    
    var description: String { get }
    var supply: String? { get }
}

extension UVIndex: UVProtocol {
    
    var description: String {
        switch self.category {
        case .low:
            return "낮음"
        case .moderate:
            return "보통"
        case .high:
            return "높음"
        case .veryHigh:
            return "매우 높음"
        case .extreme:
            return "위험"
        }
    }
    
    var supply: String? {
        switch self.category {
        case .high, .veryHigh, .extreme:
            return "선크림"
        case .low, .moderate:
            return nil
        }
    }
}
