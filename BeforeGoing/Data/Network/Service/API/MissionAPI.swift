//
//  MissionAPI.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

import Alamofire

enum MissionAPI {
    case getMissions(accessToken: String, scenarioID: Int, date: String)
    case checkMission(accessToken: String, missionID: Int, date: String, isChecked: Bool)
}

extension MissionAPI: EndPoint {
    
    var basePath: String {
        "/v1"
    }

    var url: String {
        let basePath = Environment.baseURL + basePath
        
        switch self {
        case .getMissions(_, let scenarioID, _):
            return basePath + "/scenarios/\(scenarioID)/missions"
        case .checkMission(_, let missionID, _, _):
            return basePath + "/missions/\(missionID)/check"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getMissions:
            return .get
        case .checkMission:
            return .patch
        }
    }

    var parameters: [String : Any]? {
        return nil
    }

    var headers: HTTPHeaders? {
        switch self {
        case .getMissions(let accessToken, _, _), .checkMission(let accessToken, _, _, _):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }

    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .getMissions:
            return URLEncoding.default
        case .checkMission(_, _, _, let isChecked):
            return SingleBoolEncoding(value: isChecked)
        }
    }

    var queryParameters: [String : String]? {
        switch self {
        case .getMissions(_, _, let date), .checkMission(_, _, let date, _):
            return ["date": date]
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .getMissions, .checkMission:
            return nil
        }
    }

    var isNeedReissue: Bool {
        return true
    }
}
