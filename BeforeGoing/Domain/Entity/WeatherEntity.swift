//
//  WeatherEntity.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

struct WeatherEntity {
    let weather: WeatherType
    let fineDust: FineDustType
    let uv: UVType
    
    func mapSupplies() -> [SupplyType] {
        var supplies: [SupplyType] = []
        
        if isNeedUmbrella {
            supplies.append(.umbrella)
        }
        if isNeedMask {
            supplies.append(.mask)
        }
        if isNeedParasol {
            supplies.append(.parasol)
        }
        return supplies
    }
    
    func mapInformation() -> [WeatherInformationType?] {
        let information: [WeatherInformationType?] = [
            mapWeatherInformation(weatherType: weather),
            mapFineDustInformation(fineDustType: fineDust),
            mapUVInformation(uvType: uv)
        ]
        return information
    }
    
    private var isNeedUmbrella: Bool {
        weather == .rain || weather == .snow || weather == .sleet
    }
    
    private var isNeedMask: Bool {
        fineDust == .bad || fineDust == .veryBad
    }
    
    private var isNeedParasol: Bool {
        uv == .normal || uv == .high || uv == .veryHigh
    }
    
    private func mapWeatherInformation(weatherType: WeatherType) -> WeatherInformationType? {
        switch weatherType {
        case .sunny:
            return .sunny
        case .cloudy:
            return .cloudy
        case .rain:
            return .rain
        case .sleet:
            return .sleet
        case .snow:
            return .snow
        case .shower:
            return .shower
        default:
            return nil
        }
    }
    
    private func mapFineDustInformation(fineDustType: FineDustType) -> WeatherInformationType? {
        switch fineDustType {
        case .good:
            return .fineDustGood
        case .normal:
            return .fineDustNormal
        case .bad:
            return .fineDustBad
        case .veryBad:
            return .fineDustVeryBad
        default:
            return nil
        }
    }
    
    private func mapUVInformation(uvType: UVType) -> WeatherInformationType? {
        switch uvType {
        case .veryLow, .low:
            return .uvLow
        case .normal:
            return .uvNormal
        case .high:
            return .uvHigh
        case .veryHigh:
            return .uvVeryHigh
        default:
            return nil
        }
    }
}

extension WeatherEntity {
    static func stub() -> Self {
        .init(
            weather: .unknown,
            fineDust: .unknown,
            uv: .unknown
        )
    }
}
