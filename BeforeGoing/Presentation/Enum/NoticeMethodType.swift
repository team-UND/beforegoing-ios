//
//  NoticeMethodType.swift
//  BeforeGoing
//
//  Created by APPLE on 9/4/25.
//

import UIKit

enum NoticeMethodType: String, CaseIterable {
    
    case push, alarm
    
    var component: NoticeMethodComponent {
        switch self {
        case .push:
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
    
    static func findMethod(value: String) -> Self? {
        for method in Self.allCases {
            if method.rawValue.uppercased() == value {
                return method
            }
        }
        return nil
    }
    
    var isPush: Bool {
        self == .push
    }
    
    func convertIdentifier() -> String {
        isPush ? NotificationIdentifier.pushNotice.identifier : NotificationIdentifier
            .callNotice(sequence: .first).identifier
    }
}

struct NoticeMethodComponent {
    let unSelectedImage: UIImage
    let selectedImage: UIImage
    let methodName: String
    let radioButton: RadioButton
}
