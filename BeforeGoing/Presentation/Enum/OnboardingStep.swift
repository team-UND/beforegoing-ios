//
//  OnboardingStep.swift
//  BeforeGoing
//
//  Created by APPLE on 9/6/25.
//

import UIKit

enum OnboardingStep: Int, CaseIterable {
    
    case first
    case second
    case third
    case fourth
    case fifth
    case end
    
    var component: OnboardingComponent {
        return .init(
            title: self.title,
            description: self.description,
            image: self.image,
            buttonTitle: self.buttonTitle
        )
    }
    
    private var title: String {
        switch self {
        case .first: "반가워요!\n전 당신의 습관파트너 워리예요"
        case .second: "#간편한 시나리오 계획 세우기"
        case .third: "#걱정은 미션으로 없애기"
        case .fourth: "#기상예보 기반 추천 기능"
        case .fifth: "#나가기전에 알림"
        case .end: "나가기전에"
        }
    }
    
    private var description: String {
        switch self {
        case .first: "이제부터 나가기전에에 대해 알려드릴게요"
        case .second: "시간별/위치별로\n시나리오 템플릿이 제공돼요"
        case .third: "홈에서 완료한 미션을 체크하고,\n오늘만 할일을 따로 추가, 관리 할 수 있어요"
        case .fourth: "날씨 확인을 미처 못하셨나요?\n걱정하지 마세요! 워리가 알려드릴게요"
        case .fifth: "미션을 잊지 않도록\n알림을 보내드려요!"
        case .end: "나만의 시나리오를 만들고\n워리와 함께 걱정을 가볍게 털어내봐요!"
        }
    }
    
    private var image: UIImage {
        switch self {
        case .first: return .worryOnboarding
        case .second: return .alarmBlue
        case .third: return .alarmBlue
        case .fourth: return .alarmBlue
        case .fifth: return .alarmBlue
        case .end: return .worryOnboarding
        }
    }
    
    private var buttonTitle: String {
        switch self {
        case .end: "시작하기"
        default: "다음"
        }
    }
}
