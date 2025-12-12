//
//  ScenarioTitle.swift
//  BeforeGoing
//
//  Created by APPLE on 8/24/25.
//

import UIKit

enum ScenarioType: String, CaseIterable {
    
    case mine = "나만의 시나리오 만들기"
    case outing = "외출 전"
    case goWork = "출근 전"
    case leaveWork = "퇴근 전"
    case exercise = "운동 전"
    case morning = "모닝 루틴"
    case night = "나이트 루틴"
    case publicTransport = "대중교통 내리기 전"
    case privateCar = "자가용 내리기 전"
    
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
        case .morning:
            return "아침을 시작하는 나만의 루틴"
        case .mine:
            return "여행, 면접, 공모전 등 나만의 상황에 적합하게!"
        case .night:
            return "하루를 마무리하는 나만의 루틴"
        case .publicTransport:
            return "대중교통 내리기 전, 놓치기 쉬운 준비물"
        case .privateCar:
            return "자가용 내리기 전, 놓치기 쉬운 준비물"
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
        case .morning:
            return .sun
        case .mine:
            return .heart
        case .night:
            return .night
        case .publicTransport:
            return .bus
        case .privateCar:
            return .car
        }
    }
    
    var basicMissions: [String] {
        switch self {
        case .outing:
            return ["가스불 끄기",
                    "멀티탭 전원 끄기",
                    "고데기 끄기",
                    "에어컨 / 보일러 끄기",
                    "조명 불 끄기",
                    "창문 / 베란다 문 단속",
                    "지갑 / 카드 챙기기",
                    "현관문 단속"]
        case .goWork:
            return ["업무용 전자기기 확인",
                    "점심 도시락 챙기기",
                    "회사 출입증 챙기기",
                    "지갑 / 카드 챙기기",
                    "가스불 끄기",
                    "멀티탭 전원 끄기",
                    "고데기 끄기",
                    "에어컨 / 보일러 끄기",
                    "조명 불 끄기",
                    "창문 / 베란다 문 단속",
                    "현관문 단속",
                    "텀블러 챙기기"]
        case .leaveWork:
            return ["PC 전원 끄기",
                    "업무용 계정 로그아웃",
                    "중요 문서 저장 확인",
                    "오늘 업무 진행 상황 정리",
                    "메일 확인 및 답변",
                    "책상 및 서류 정리",
                    "텀블러 세척",
                    "회사 출입증 챙기기"]
        case .exercise:
            return ["운동복 챙기기",
                    "운동화 챙기기",
                    "텀블러 챙기기",
                    "단백질 보충제 챙기기",
                    "스마트워치 착용",
                    "에어팟 / 버즈 챙기기",
                    "회원권 챙기기",
                    "샤워도구 챙기기",
                    "스트랩 챙기기"]
        case .morning:
            return ["아침 6시 기상",
                    "침대 정리하기",
                    "창문 열고 환기하기",
                    "물 한 잔 마시기",
                    "가벼운 스트레칭",
                    "공복 유산소 하기",
                    "건강한 아침식사",
                    "오늘의 할 일 작성",
                    "책 10페이지 읽기",
                    "뉴스 스크랩",
                    "아침 명상"]
        case .mine:
            return []
        case .night:
            return ["나이트 스킨케어",
                    "간단한 스트레칭",
                    "저녁 명상",
                    "오늘의 일기 쓰기",
                    "내일 계획 세우기",
                    "영양제 챙겨먹기",
                    "책 10페이지 읽기"]
        case .publicTransport:
            return ["에어팟 / 이어폰 챙기기",
                    "휴대폰 챙기기",
                    "지갑 / 교통카드 챙기기",
                    "노트북 / 태블릿 챙기기",
                    "책 / 프린트물 챙기기",
                    "우산 챙기기",
                    "가방 챙기기",
                    "좌석, 발 밑 물건 확인"]
        case .privateCar:
            return ["차 키 챙기기",
                    "차량 문단속 확인",
                    "실내등 확인",
                    "전조등 확인",
                    "시동 off 확인",
                    "에어팟 / 이어폰 챙기기",
                    "휴대폰 챙기기",
                    "지갑 / 교통카드 챙기기",
                    "노트북 / 태블릿 챙기기",
                    "책 / 프린트물 챙기기",
                    "우산 챙기기",
                    "가방 챙기기"]
        }
    }
}
