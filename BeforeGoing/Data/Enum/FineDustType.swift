//
//  Untitled.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

enum FineDustType: String, CaseIterable {
    case unknown
    case good
    case normal
    case bad
    case veryBad
    
    init?(value: String) {
        if let fineDustType = FineDustType.allCases.first(where: { $0.value == value }) {
            self = fineDustType
            return
        }
        return nil
    }
    
    private var value: String {
        var value = ""
        for char in self.rawValue {
            if char.isUppercase {
                value.append("_")
            }
            value.append(char.uppercased())
        }
        return value
    }
}
