//
//  WeatherInformationType.swift
//  BeforeGoing
//
//  Created by APPLE on 9/25/25.
//

enum WeatherInformationType: String {
    
    case sunny = "맑음"
    case cloudy = "흐림"
    case rain = "비 소식"
    case sleet = "비/눈 소식"
    case snow = "눈 소식"
    case shower = "소나기 소식"
    
    case fineDustGood = "미세먼지 좋음"
    case fineDustNormal = "미세먼지 보통"
    case fineDustBad = "미세먼지 나쁨"
    case fineDustVeryBad = "미세먼지 매우 나쁨"
    
    case uvLow = "자외선 낮음"
    case uvNormal = "자외선 보통"
    case uvHigh = "자외선 높음"
    case uvVeryHigh = "자외선 매우 높음"
}
