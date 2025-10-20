//
//  AgreeItem.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

enum AgreeItem: CaseIterable {
    
    case isTermsOfServiceAgreed
    case isPrivacyPolicyAgreed
    case isOverFourteen
    case isPushAgreed
    
    var component: AgreeComponent {
        switch self {
        case .isTermsOfServiceAgreed:
            return AgreeComponent(
                text: AgreeItemLiteral.termsOfServiceAgreed,
                isNecessary: true,
                canMoveToSetting: true
            )
        case .isPrivacyPolicyAgreed:
            return AgreeComponent(
                text: AgreeItemLiteral.privacyPolicyAgreed,
                isNecessary: true,
                canMoveToSetting: true
            )
        case .isOverFourteen:
            return AgreeComponent(
                text: AgreeItemLiteral.overFourteen,
                isNecessary: true,
                canMoveToSetting: false
            )
        case .isPushAgreed:
            return AgreeComponent(
                text: AgreeItemLiteral.pushAgreed,
                isNecessary: false,
                canMoveToSetting: false
            )
        }
    }
}
