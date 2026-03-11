//
//  DaysOfWeek.swift
//  BeforeGoing
//
//  Created by APPLE on 10/2/25.
//

enum DaysOfWeek: Int, CaseIterable {
    case monday = 0, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var string: String {
        switch self {
        case .monday:
            return "월"
        case .tuesday:
            return "화"
        case .wednesday:
            return "수"
        case .thursday:
            return "목"
        case .friday:
            return "금"
        case .saturday:
            return "토"
        case .sunday:
            return "일"
        }
    }
    
    static func toRawvalues(daysString: String) -> [Int] {
        let daysOfWeek = daysString
            .split(separator: ",")
            .compactMap { day in
                DaysOfWeek.allCases
                    .first { $0.string == day }?
                    .rawValue
            }
        return daysOfWeek
    }
}
