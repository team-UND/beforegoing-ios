//
//  ScenarioAPI.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

import Alamofire

enum ScenarioAPI {
    case getDetailScenario(accessToken: String, scenarioID: Int)
    case addScnearioWithNotification(accessToken: String, dto: WithNotificationAddScenarioRequestDTO)
    case addScnearioWithoutNotification(accessToken: String, dto: WithoutNotificationAddScenarioRequestDTO)
}

extension ScenarioAPI: EndPoint {
    
    var basePath: String {
        "/v1/scenarios"
    }

    var url: String {
        let basePath = Environment.baseURL + basePath
        
        switch self {
        case .getDetailScenario, .addScnearioWithNotification, .addScnearioWithoutNotification:
            return basePath
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getDetailScenario:
            return .get
        case .addScnearioWithNotification, .addScnearioWithoutNotification:
            return .post
        }
    }

    var parameters: [String : Any]? {
        return nil
    }

    var headers: HTTPHeaders? {
        switch self {
        case .getDetailScenario(let accessToken, _),
             .addScnearioWithNotification(let accessToken, _),
             .addScnearioWithoutNotification(let accessToken, _):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }

    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .getDetailScenario:
            return URLEncoding.default
        case .addScnearioWithNotification, .addScnearioWithoutNotification:
            return JSONEncoding.default
        }
    }

    var queryParameters: [String : String]? {
        switch self {
        case .getDetailScenario(_, let scenarioID):
            return ["scenarioId": "\(scenarioID)"]
        case .addScnearioWithNotification, .addScnearioWithoutNotification:
            return nil
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .getDetailScenario:
            return nil
        case .addScnearioWithNotification(_, let dto):
            return try? dto.toBodyParameters()
        case .addScnearioWithoutNotification(_, let dto):
            return try? dto.toBodyParameters()
        }
    }

    var isNeedReissue: Bool {
        return true
    }
}
