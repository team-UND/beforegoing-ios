//
//  HapticManager.swift
//  BeforeGoing
//
//  Created by APPLE on 10/7/25.
//

import UIKit

final class HapticManager {
    
    static let shared = HapticManager()
    private init() {}
    
    private let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    func notice(feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        notificationFeedbackGenerator.do {
            $0.prepare()
            $0.notificationOccurred(feedbackType)
        }
    }
    
    func impact() {
        impactFeedbackGenerator.do {
            $0.prepare()
            $0.impactOccurred()
        }
    }
}
