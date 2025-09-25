//
//  WeatherAPI.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

import Alamofire

enum WeatherAPI {
    case weather(
        accessToken: String,
        date: String,
        timezone: String,
        dto: WeatherRequestDTO
    )
}

extension WeatherAPI: EndPoint {
    
    var basePath: String {
        switch self {
        case .weather:
            "/v1/weather"
        }
    }
    
    var url: String {
        switch self {
        case .weather:
            Environment.baseURL + basePath
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .weather:
                .post
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .weather:
            nil
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .weather(let accessToken, _, _, _):
            [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }
    
    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .weather:
            JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .weather(_, let date, let timezone, _):
            [
                "date": date,
                "timezone": timezone
            ]
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .weather(_, _, _, let dto):
            try? dto.toBodyParameters()
        }
    }
    
    var isNeedReissue: Bool {
        return true
    }
}
