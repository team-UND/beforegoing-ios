//
//  MemberAPI.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

import Alamofire

enum MemberAPI {
    case updateNickname(accessToken: String, dto: UpdateNicknameRequestDTO)
    case withdraw(accessToken: String)
    case fetchMemberName(accessToken: String)
}

extension MemberAPI: EndPoint {
    
    var basePath: String {
        "/v1/member"
    }
    
    var url: String {
        let basePath = Environment.baseURL + basePath
        
        switch self {
        case .updateNickname, .fetchMemberName:
            return basePath + "/nickname"
        case .withdraw:
            return basePath
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .updateNickname:
            return .patch
        case .withdraw:
            return .delete
        case .fetchMemberName:
            return .get
        }
    }

    var parameters: [String : Any]? {
        nil
    }

    var headers: HTTPHeaders? {
        switch self {
        case .updateNickname(let accessToken, _), .withdraw(let accessToken), .fetchMemberName(let accessToken):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }

    var parameterEncoding: any ParameterEncoding {
        switch self {
        case .updateNickname, .fetchMemberName:
            return JSONEncoding.default
        case .withdraw:
            return URLEncoding.default
        }
    }

    var queryParameters: [String : String]? {
        nil
    }

    var bodyParameters: Parameters? {
        switch self {
        case .updateNickname(_, let dto):
            return try? dto.toBodyParameters()
        case .withdraw, .fetchMemberName:
            return nil
        }
    }
    
    var isNeedReissue: Bool {
        return true
    }
}
