//
//  UVLevel.swift
//  BeforeGoing
//
//  Created by 더스틴 on 10/11/26.
//

enum UVLevel {
    case low
    case moderate
    case high
    case veryHigh
    case extreme
}

extension UVLevel {
    
    var description: String {
        switch self {
        case .low:
            return "낮음"
        case .moderate:
            return "보통"
        case .high:
            return "높음"
        case .veryHigh:
            return "매우 높음"
        case .extreme:
            return "위험"
        }
    }
    
    var supply: String? {
        switch self {
        case .high, .veryHigh, .extreme:
            return "선크림"
        case .low, .moderate:
            return nil
        }
    }
}
