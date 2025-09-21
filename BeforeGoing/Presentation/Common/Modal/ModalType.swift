//
//  ModalType.swift
//  BeforeGoing
//
//  Created by APPLE on 9/5/25.
//

enum ModalType {
    
    case expirationLogin, logout, withdraw
    
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
        }
    }
}
