//
//  UVType.swift
//  BeforeGoing
//
//  Created by APPLE on 9/23/25.
//

enum UVType: String, CaseIterable {
    case unknown
    case veryLow
    case low
    case normal
    case high
    case veryHigh
    
    init?(value: String) {
        if let uvType = UVType.allCases.first(where: { $0.value == value }) {
            self = uvType
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
