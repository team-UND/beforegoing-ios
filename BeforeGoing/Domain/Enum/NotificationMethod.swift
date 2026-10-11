//
//  NotificationMethod.swift
//  BeforeGoing
//
//  Created by 더스틴 on 10/11/26.
//

enum NotificationMethod: String, CaseIterable {
    case push = "push"
    case alarm = "alarm"
    
    var isPush: Bool {
        self == .push
    }
}
