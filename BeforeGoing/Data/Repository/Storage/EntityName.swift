//
//  EntityName.swift
//  BeforeGoing
//
//  Created by APPLE on 2/9/26.
//

enum EntityName: String {
    case member
    case mission
    case notification
    case scenario
    case terms
    case timeNotification
    
    var string: String {
        self.rawValue.capitalized
    }
}
