//
//  Encodable+.swift
//  BeforeGoing
//
//  Created by APPLE on 9/10/25.
//

import Foundation

extension Encodable {
    
    func toBodyParameters() throws -> [String: Any]? {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        let bodyParameters = jsonData as? [String: Any]
        
        return bodyParameters
    }
}
