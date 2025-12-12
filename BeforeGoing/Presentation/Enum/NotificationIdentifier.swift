//
//  NotificationIdentifier.swift
//  BeforeGoing
//
//  Created by APPLE on 10/7/25.
//

import Foundation

enum NotificationIdentifier: CaseIterable {
    
    static var allCases: [NotificationIdentifier] {
        var cases: [NotificationIdentifier] = [.pushNotice, .terminate]
        
        NotificationSequence.allCases.forEach {
            cases.append(.callNotice(sequence: $0))
        }
        
        return cases
    }
    
    case pushNotice
    case callNotice(sequence: NotificationSequence)
    case terminate
    
    var identifier: String {
        switch self {
        case .pushNotice:
            return "PUSH_NOTICE"
        case .callNotice(let sequence):
            return "CALL_NOTICE\(sequence)"
        case .terminate:
            return "TERMINATE"
        }
    }
    
    static func convertIdentifier(from identifier: String) -> Self? {
        Self.allCases.first(where: { identifier.hasPrefix($0.identifier) })
    }
    
    static func isCallNotice(identifier: String) -> Bool {
        identifier.hasPrefix("CALL_NOTICE")
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
