//
//  NotificationViewType.swift
//  BeforeGoing
//
//  Created by APPLE on 10/7/25.
//

import UIKit

enum NotificationViewType {
    case first
    case second
    case last
    
    init(sequence: NotificationSequence) {
        switch sequence {
        case .first:
            self = .first
        case .second:
            self = .second
        case .last:
            self = .last
        }
    }
    
    var backgroundImage: UIImage {
        switch self {
        case .first:
            return .firstNotification
        case .second:
            return .secondNotification
        case .last:
            return .lastNotification
        }
    }
    
    var actions: [NotificationAction] {
        switch self {
        case .first, .second:
            return [.turnOff, .again]
        case .last:
            return [.turnOff]
        }
    }
    
    var mainTitleColor: UIColor {
        switch self {
        case .first, .second:
            return .blue500
        case .last:
            return .warning800
        }
    }
}
