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
        guard let date = calendar.date(from: components) else {
            fatalError("Failed to create date from components. This should not happen.")
        }
        return date
    }
    
    static func getPreviousMonth(from date: Date) -> Date {
        return getMonth(from: date, offset: -1)
    }

    static func getNextMonth(from date: Date) -> Date {
        return getMonth(from: date, offset: 1)
    }
    
    private static func getMonth(from date: Date, offset: Int) -> Date {
        guard let date = calendar.date(byAdding: .month, value: offset, to: date) else {
            fatalError("Failed to create date from components. This should not happen.")
        }
        return date
    }
}
