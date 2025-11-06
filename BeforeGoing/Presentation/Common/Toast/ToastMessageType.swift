//
//  ToastMessageType.swift
//  BeforeGoing
//
//  Created by APPLE on 11/2/25.
//

import UIKit

enum ToastMessageType {
    
    case todayMissionLimit
    case missionLimit
    case duplicateMission
    
    var message: String {
        switch self {
        case .todayMissionLimit:
            return "* 오늘의 미션은 20개까지만 설정할 수 있어요"
        case .missionLimit:
            return "* 미션은 20개까지만 설정할 수 있어요"
        case .duplicateMission:
            return "* 중복된 이름의 미션은 설정할 수 없어요"
        }
    }
}
