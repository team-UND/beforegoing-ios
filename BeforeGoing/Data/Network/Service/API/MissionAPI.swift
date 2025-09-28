//
//  MissionAPI.swift
//  BeforeGoing
//
//  Created by APPLE on 9/27/25.
//

import Alamofire

enum MissionAPI {
    case getMissions(accessToken: String, scenarioID: Int, date: String)
}

extension MissionAPI: EndPoint {
    
    var basePath: String {
        "/v1"
    }

    var url: String {
        let basePath = Environment.baseURL + basePath
        
        switch self {
        case .getMissions(_, let scenarioID, _):
            return basePath + "/scenarios" + "/\(scenarioID)" + "/missions"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getMissions:
            return .get
        }
    }

    var parameters: [String : Any]? {
        return nil
    }

    var headers: HTTPHeaders? {
        switch self {
        case .getMissions(let accessToken, _, _):
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
        }
    }

    var queryParameters: [String : String]? {
        switch self {
        case .getMissions(_, _, let date):
            return ["date": date]
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .getMissions:
            return nil
        }
    }

    var isNeedReissue: Bool {
        return true
    }
}
