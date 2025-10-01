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
    case addTodayMission(accessToken: String, scenarioID: Int, date: String, dto: AddTodayMissionRequestDTO)
    case deleteTodayMission(accessToken: String, missionID: Int)
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
        case .addTodayMission(_, let scenarioID, _, _):
            return basePath + "/scenarios/\(scenarioID)/missions/today"
        case .deleteTodayMission(_, let missionID):
            return basePath + "/missions/\(missionID)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMissions:
            return .get
        case .checkMission:
            return .patch
        case .addTodayMission:
            return .post
        case .deleteTodayMission:
            return .delete
        }
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getMissions(let accessToken, _, _),
                .checkMission(let accessToken, _, _, _),
                .addTodayMission(let accessToken, _, _, _):
                .deleteTodayMission(let accessToken, _)
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }
    
    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .getMissions, .deleteTodayMission:
            return URLEncoding.default
        case .checkMission(_, _, _, let isChecked):
            return SingleBoolEncoding(value: isChecked)
        case .addTodayMission:
            return JSONEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .getMissions(_, _, let date), .checkMission(_, _, let date, _), .addTodayMission(_, _, let date, _):
            return ["date": date]
        case .deleteTodayMission:
            return nil
        }
    }
    
    var bodyParameters: Parameters? {
        switch self {
        case .getMissions, .checkMission, .deleteTodayMission:
            return nil
        case .addTodayMission(_, _, _, let dto):
            return try? dto.toBodyParameters()
        }
    }
    
    var isNeedReissue: Bool {
        return true
    }
}
