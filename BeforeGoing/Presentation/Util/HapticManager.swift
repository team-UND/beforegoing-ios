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
    
    func impact() {
        let type = UINotificationFeedbackGenerator.FeedbackType.error
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
