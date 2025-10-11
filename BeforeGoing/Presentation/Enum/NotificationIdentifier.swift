//
//  NotificationIdentifier.swift
//  BeforeGoing
//
//  Created by APPLE on 10/7/25.
//

import Foundation

enum NotificationIdentifier: CaseIterable {
    
    static var allCases: [NotificationIdentifier] {
        var cases: [NotificationIdentifier] = [
            .remind,
            .pushNotice
        ]
        
        NotificationSequence.allCases.forEach {
            cases.append(.callNotice(sequence: $0))
        }
        
        return cases
    }
    
    case remind
    case pushNotice
    case callNotice(sequence: NotificationSequence)
    
    var identifier: String {
        switch self {
        case .remind:
            return "REMIND"
        case .pushNotice:
            return "PUSH_NOTICE"
        case .callNotice(let sequence):
            return "CALL_NOTICE\(sequence)"
        }
    }
    
    static func convertIdentifier(from identifier: String) -> Self? {
        Self.allCases.first(where: { identifier.hasPrefix($0.identifier) })
    }
    
    func nextCallNotice(text: String) -> String? {
        guard case .callNotice(let sequence) = self,
              let newSequence = sequence.next() else {
            return nil
        }
        let prefix = Self.callNotice(sequence: newSequence).identifier
        let suffix = text.dropFirst(prefix.count)
        return prefix + suffix
    }
}
