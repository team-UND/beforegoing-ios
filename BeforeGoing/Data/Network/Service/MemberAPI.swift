//
//  MemberAPI.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

import Alamofire

enum MemberAPI {
    case terms(accessToken: String, dto: TermsRequestDTO)
}

extension MemberAPI: EndPoint {
    
    var basePath: String {
        "/v1/terms"
    }
    
    var url: String {
        let basePath = Environment.baseURL + basePath
        
        switch self {
        case .terms:
            return basePath
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .terms:
            return .post
        }
    }

    var parameters: [String : Any]? {
        nil
    }

    var headers: HTTPHeaders? {
        switch self {
        case .terms(let accessToken, _):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }

    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .terms:
            return JSONEncoding.default
        }
    }

    var queryParameters: [String : String]? {
        nil
    }

    var bodyParameters: Parameters? {
        switch self {
        case .terms(_, let dto):
            return try? dto.toBodyParameters()
        }
    }
    
    var isNeedReissue: Bool {
        return true
    }
}

