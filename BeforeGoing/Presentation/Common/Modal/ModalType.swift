//
//  ModalType.swift
//  BeforeGoing
//
//  Created by APPLE on 9/5/25.
//

enum ModalType {
    
    case expirationLogin
    case logout
    case withdraw
    case tooManyRequest
    case eventPushAgree(isAgreed: Bool, currentDate: String)
    case serviceUnavailable
    
    var component: ModalComponent {
        switch self {
        case .expirationLogin:
            return .init(
                image: .worry,
                mainTitle: "로그인이 만료되었어요",
                description: "더 안전한 앱 사용을 위해\n다시 로그인 해주세요:)",
                dismissTitle: "취소",
                actionTitle: "확인"
            )
        case .logout:
            return .init(
                image: .worry,
                mainTitle: "로그아웃",
                description: "로그아웃하시겠어요?",
                dismissTitle: "취소",
                actionTitle: "확인"
            )
        case .withdraw:
            return .init(
                image: .withdrawWorry,
                mainTitle: "회원 탈퇴",
                description: "지금까지의 기록이 모두 사라지며\n복구되지 않아요.\n정말 탈퇴하실 건가요?",
                dismissTitle: "취소",
                actionTitle: "탈퇴하기"
            )
        case .tooManyRequest:
            return .init(
                image: .withdrawWorry,
                mainTitle: "응답 제한",
                description: "너무 많은 수의 요청을 보냈어요",
                dismissTitle: nil,
                actionTitle: "확인"
            )
        case .eventPushAgree(let isAgreed, let currentDate):
            let agreeStatus = isAgreed ? "수신 동의" : "수신 거부"
            return .init(
                image: nil,
                mainTitle: nil,
                description: "[나가기전에]에서 보내는 이벤트/마케팅 관련\n푸시알림 수신 여부가 ‘\(agreeStatus)’로\n변경되었습니다.\n\(currentDate)",
                dismissTitle: nil,
                actionTitle: "확인"
            )
        case .serviceUnavailable:
            return .init(
                image: .withdrawWorry,
                mainTitle: "지금은 서비스가 원활하지 않아요",
                description: "잠시 후 다시 시도해주세요!",
                dismissTitle: nil,
                actionTitle: "확인"
            )
        }
    }
}
