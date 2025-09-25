//
//  EndPoint.swift
//  BeforeGoing
//
//  Created by APPLE on 9/10/25.
//

import Foundation

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
    var isNeedReissue: Bool { get }
}

extension EndPoint {
    
    var requestURL: URL {
var requestURL: URL {
    guard var urlComponents = URLComponents(string: url) else {
        fatalError("Invalid URL string in EndPoint: \(url)")
    }
    
    if let queryParameters {
        urlComponents.queryItems = queryParameters.map {
            URLQueryItem(name: $0, value: $1)
        }
    }
    
    guard let url = urlComponents.url else {
        fatalError("Could not construct URL with query parameters for: \(url)")
    }
    
    return url
}
}
