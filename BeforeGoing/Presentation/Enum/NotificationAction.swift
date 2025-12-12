//
//  NotificationAction.swift
//  BeforeGoing
//
//  Created by APPLE on 10/7/25.
//

import UIKit

enum NotificationAction {
    
    case turnOff
    case again
    
    var image: UIImage {
        switch self {
        case .turnOff:
            return .turnoffNotice
        case .again:
            return .againNotice
        }
    }
    
    var description: String {
        switch self {
        case .turnOff:
            return "알람 끄기"
        case .again:
            return "5분 뒤 다시"
        }
    }
}
