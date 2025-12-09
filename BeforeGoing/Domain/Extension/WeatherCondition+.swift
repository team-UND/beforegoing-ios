//
//  WeatherCondition+.swift
//  BeforeGoing
//
//  Created by APPLE on 12/9/25.
//

import WeatherKit

extension WeatherCondition {
    
    var description: String {
        switch self {
        case .blizzard, .blowingSnow, .flurries, .heavySnow, .sleet, .snow, .sunFlurries:
            return "눈"
        case .blowingDust:
            return "황사"
        case .breezy, .hurricane, .windy:
            return "바람"
        case .clear, .mostlyClear:
            return "맑음"
        case .cloudy, .mostlyCloudy, .partlyCloudy:
            return "흐림"
        case .drizzle, .freezingDrizzle, .freezingRain, .heavyRain, .rain, .strongStorms, .sunShowers, .tropicalStorm:
            return "비"
        case .foggy, .haze, .smoky:
            return "안개"
        case .frigid:
            return "강한 추위"
        case .hail:
            return "우박"
        case .hot:
            return "강한 더위"
        case .isolatedThunderstorms, .scatteredThunderstorms, .thunderstorms:
            return "천둥·번개"
        case .wintryMix:
            return "눈·비"
        @unknown default:
            return "알 수 없는 날씨"
        }
    }
    
    var supply: String? {
        switch self {
        case .blizzard, .blowingSnow, .flurries, .heavySnow, .sleet, .snow, .sunFlurries,
                .drizzle, .freezingDrizzle, .freezingRain, .heavyRain, .rain, .strongStorms, .sunShowers, .tropicalStorm,
                .hail:
            return "우산"
        case .blowingDust:
            return "마스크"
        default:
            return nil
        }
    }
}
