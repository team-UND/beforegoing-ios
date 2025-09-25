//
//  WeatherType.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

enum WeatherType: String, CaseIterable {
    case unknown
    case sunny
    case cloudy
    case overcast
    case rain
    case sleet
    case snow
    case shower
    
    private var value: String {
        self.rawValue.uppercased()
    }
    
    init?(value: String) {
        if let weatherType = WeatherType.allCases.first(where: { $0.value == value }) {
            self = weatherType
            return
        }
        return nil
    }
}
