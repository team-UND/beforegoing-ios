//
//  WeatherResponseMapper.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

struct WeatherResponseMapper: Mapper {
    
    typealias Input = WeatherResponseDTO
    typealias Output = (weather: WeatherType, fineDust: FineDustType, uv: UVType)

    func map(_ input: WeatherResponseDTO) -> (
        weather: WeatherType,
        fineDust: FineDustType,
        uv: UVType
    ) {
        guard let weather = WeatherType(value: input.weather),
              let fineDust = FineDustType(value: input.fineDust),
              let uv = UVType(value: input.uv) else {
            return (.unknown, .unknown, .unknown)
        }
        return (weather: weather, fineDust: fineDust, uv: uv)
    }
}
