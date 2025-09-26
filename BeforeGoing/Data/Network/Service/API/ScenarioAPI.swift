//
//  ScenarioAPI.swift
//  BeforeGoing
//
//  Created by APPLE on 9/26/25.
//

import Alamofire

enum ScenarioAPI {
    case getScenarios(accessToken: String)
    case addScnearioWithNotification(accessToken: String, dto: WithNotificationAddScenarioRequestDTO)
    case addScnearioWithoutNotification(accessToken: String, dto: WithoutNotificationAddScenarioRequestDTO)
    case deleteScenario(accessToken: String, scenarioID: Int)
    case updateOrder(accessToken: String, scenarioID: Int, dto: UpdateScenarioOrderRequestDTO)
}

extension ScenarioAPI: EndPoint {
    
    var basePath: String {
        "/v1/scenarios"
    }
    
    var url: String {
        let basePath = Environment.baseURL + basePath
        
        switch self {
        case .getScenarios, .addScnearioWithNotification, .addScnearioWithoutNotification:
            return basePath
        case .deleteScenario(_, let scenarioID):
            return basePath + "/\(scenarioID)"
        case .updateOrder(_, let scenarioID, _):
            return basePath + "/\(scenarioID)" + "/order"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getScenarios:
            return .get
        case .addScnearioWithNotification, .addScnearioWithoutNotification:
            return .post
        case .deleteScenario:
            return .delete
        case .updateOrder:
            return .patch
        }
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getScenarios(let accessToken),
                .addScnearioWithNotification(let accessToken, _),
                .addScnearioWithoutNotification(let accessToken, _),
                .deleteScenario(let accessToken, _),
                .updateOrder(let accessToken, _, _):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }
    
    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .getScenarios, .deleteScenario:
            return URLEncoding.default
        case .addScnearioWithNotification, .addScnearioWithoutNotification, .updateOrder:
            return JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .getScenarios,
                .addScnearioWithNotification,
                .addScnearioWithoutNotification,
                .deleteScenario,
                .updateOrder:
            return nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getScenarios, .deleteScenario:
            return nil
        case .addScnearioWithNotification(_, let dto):
            return try? dto.toBodyParameters()
        case .addScnearioWithoutNotification(_, let dto):
            return try? dto.toBodyParameters()
        case .updateOrder(_, _, let dto):
            return try? dto.toBodyParameters()
        }
    }
    
    var isNeedReissue: Bool {
        return true
    }
}
