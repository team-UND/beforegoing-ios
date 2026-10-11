//
//  WeatherKind+.swift
//  BeforeGoing
//
//  Created by 더스틴 on 10/11/26.
//

import WeatherKit

extension WeatherKind {
    
    init?(_ condition: WeatherCondition) {
        switch condition {
        case .blizzard: self = .blizzard
        case .blowingSnow: self = .blowingSnow
        case .flurries: self = .flurries
        case .heavySnow: self = .heavySnow
        case .sleet: self = .sleet
        case .snow: self = .snow
        case .sunFlurries: self = .sunFlurries
        case .blowingDust: self = .blowingDust
        case .breezy: self = .breezy
        case .hurricane: self = .hurricane
        case .windy: self = .windy
        case .clear: self = .clear
        case .mostlyClear: self = .mostlyClear
        case .cloudy: self = .cloudy
        case .mostlyCloudy: self = .mostlyCloudy
        case .partlyCloudy: self = .partlyCloudy
        case .drizzle: self = .drizzle
        case .freezingDrizzle: self = .freezingDrizzle
        case .freezingRain: self = .freezingRain
        case .heavyRain: self = .heavyRain
        case .rain: self = .rain
        case .strongStorms: self = .strongStorms
        case .sunShowers: self = .sunShowers
        case .tropicalStorm: self = .tropicalStorm
        case .foggy: self = .foggy
        case .haze: self = .haze
        case .smoky: self = .smoky
        case .frigid: self = .frigid
        case .hail: self = .hail
        case .hot: self = .hot
        case .isolatedThunderstorms: self = .isolatedThunderstorms
        case .scatteredThunderstorms: self = .scatteredThunderstorms
        case .thunderstorms: self = .thunderstorms
        case .wintryMix: self = .wintryMix
        @unknown default: return nil
        }
    }
}
