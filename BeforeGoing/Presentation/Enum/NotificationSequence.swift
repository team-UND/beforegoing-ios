//
//  NotificationSequence.swift
//  BeforeGoing
//
//  Created by APPLE on 10/7/25.
//

enum NotificationSequence: Int, CaseIterable {
    case first = 1, second, last
    
    func next() -> Self? {
        if self == .last {
            return nil
        }
        return .init(rawValue: self.rawValue + 1)
    }
}
