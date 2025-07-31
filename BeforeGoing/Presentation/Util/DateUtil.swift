//
//  DateUtil.swift
//  BeforeGoing
//
//  Created by APPLE on 7/29/25.
//

import Foundation

struct DateUtil {
    
    private static let calendar = Calendar.current
    
    static func getCurrentDate() -> Date {
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        return calendar.date(from: components)!
    }
    
    static func getPreviousMonth(from date: Date) -> Date {
        return getMonth(from: date, offset: -1)
    }

    static func getNextMonth(from date: Date) -> Date {
        return getMonth(from: date, offset: 1)
    }
    
    private static func getMonth(from date: Date, offset: Int) -> Date {
        return calendar.date(byAdding: .month, value: offset, to: date)!
    }
}
