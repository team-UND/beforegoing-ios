//
//  ParameterEncoding+.swift
//  BeforeGoing
//
//  Created by APPLE on 9/30/25.
//

import Foundation

import Alamofire

struct SingleBoolValue: ParameterEncoding {
    
    private let value: Bool
    
    init(value: Bool) {
        self.value = value
    }
    
    func encode(
        _ urlRequest: any URLRequestConvertible,
        with parameters: Parameters?
    ) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        let stringValue = String(value)
        if let data = stringValue.data(using: .utf8) {
            urlRequest.httpBody = data
        }
        
        return urlRequest
    }
}
