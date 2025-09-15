//
//  EndPoint.swift
//  BeforeGoing
//
//  Created by APPLE on 9/10/25.
//

import Alamofire

protocol EndPoint {
    
    var basePath: String { get }
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: HTTPHeaders? { get }
    var parameterEncoding: ParameterEncoding { get }
    var queryParameters: [String: String]? { get }
    var bodyParameters: Parameters? { get }
}
