//
//  ListItemState.swift
//  BeforeGoing
//
//  Created by APPLE on 8/12/25.
//

enum ListItemState {
    
    case today
    case original
    
    var isToday: Bool {
        switch self {
        case .today: return true
        case .original: return false
        }
    }
}
