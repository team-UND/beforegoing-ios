//
//  NotificationMethod+.swift
//  BeforeGoing
//
//  Created by 더스틴 on 10/11/26.
//

import UIKit

extension NotificationMethod {
    
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
    
    static func convertMethodName(string: String) -> String? {
        let notificationMethod = Self.allCases.first { $0.rawValue == string.lowercased() }
        return notificationMethod?.component.methodName
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
