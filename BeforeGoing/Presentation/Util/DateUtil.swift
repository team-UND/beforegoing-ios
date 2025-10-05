//
//  DateUtil.swift
//  BeforeGoing
//
//  Created by APPLE on 7/29/25.
//

import Foundation

struct DateUtil {
    
    private static let dateFormat = "yyyy년 MM월 dd일"
    private static let seoul = "Asia/Seoul"
    private static let calendar = Calendar.current
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = TimeZone(identifier: seoul)
        return formatter
    }()
    
    static func getCurrentDate() -> Date {
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        guard let date = calendar.date(from: components) else {
            fatalError("Failed to create date from components. This should not happen.")
        }
        return date
    }
    
    static func getCurrentDate(format: String) -> String {
        let date: Date = getCurrentDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
    
    static func toString(date: Date) -> String {
        return formatter.string(from: date)
    }
    
    static func convertDateFormat(dateString: String?) -> String? {
        guard let dateString = dateString,
              let date = formatter.date(from: dateString) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        let resultString = outputFormatter.string(from: date)
        
        return resultString
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
