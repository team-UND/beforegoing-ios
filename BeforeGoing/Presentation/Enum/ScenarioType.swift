//
//  ScenarioTitle.swift
//  BeforeGoing
//
//  Created by APPLE on 8/24/25.
//

import UIKit

enum ScenarioType: String {
    
    case outing = "외출 전"
    case goWork = "출근 전"
    case leaveWork = "퇴근 전"
    case exercise = "운동 전"
    case miracle = "미라클 모닝 루틴"
    case mine = "나만의 시나리오 만들기"
    
    var subtitle: String {
        switch self {
        case .outing:
            return "집에서 나가기 전, 놓치기 쉬운 준비물/점검 사항"
        case .goWork:
            return "이동 중 목적지 도착 직전, 놓치기 쉬운 준비물"
        case .leaveWork:
            return "회사에서 나가기 전, 놓치기 쉬운 준비물"
        case .exercise:
            return "운동하러 가기 전, 놓치기 쉬운 준비물"
        case .miracle:
            return "아침을 시작하는 나만의 루틴"
        case .mine:
            return "여행, 면접, 공모전 등 나만의 상황에 적합하게!"
        }
    }
    
    var image: UIImage {
        switch self {
        case .outing:
            return .door
        case .goWork:
            return .building
        case .leaveWork:
            return .homeScenario
        case .exercise:
            return .exercise
        case .miracle:
            return .sun
        case .mine:
            return .heart
        }
    }
}
