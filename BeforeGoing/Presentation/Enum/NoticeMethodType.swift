//
//  NoticeMethodType.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

enum NoticeMethodType {
    
    case pushNotice, alarm
    
    var component: NoticeMethodComponent {
        switch self {
        case .pushNotice:
            return .init(
                unSelectedImage: .pushWhite,
                selectedImage: .pushBlue,
                methodName: "푸시 알림",
                radioButton: RadioButton(state: .enable)
            )
        case .alarm:
            return .init(
                unSelectedImage: .alarmWhite,
                selectedImage: .alarmBlue,
                methodName: "알람",
                radioButton: RadioButton(state: .disable)
            )
        }
    }
}

struct NoticeMethodComponent {
    let unSelectedImage: UIImage
    let selectedImage: UIImage
    let methodName: String
    let radioButton: RadioButton
}
