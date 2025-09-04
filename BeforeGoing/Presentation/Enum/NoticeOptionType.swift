//
//  NoticeOptionType.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

enum NoticeOptionType {
    
    case noNotice, setTimeNotice
    
    var component: NoticeOptionComponent {
        switch self {
        case .noNotice:
            return .init(
                title: "알림 없이 사용",
                radioButton: RadioButton(state: .enable)
            )
        case .setTimeNotice:
            return .init(
                title: "설정한 시간에 알림",
                radioButton: RadioButton(state: .disable)
            )
        }
    }
}

struct NoticeOptionComponent {
    let title: String
    let radioButton: RadioButton
}
