//
//  DateUtil.swift
//  BeforeGoing
//
//  Created by APPLE on 7/29/25.
//

import Foundation

struct DateUtil {
    
    private static let homeDateFormat = "yyyy년 MM월 dd일"
    private static let apiDateFormat = "yyyy-MM-dd"
    private static let monthAndDayDateFormat = "MM월 dd일"
    private static let seoul = "Asia/Seoul"
    private static let calendar = Calendar.current
    
    private static let homeDateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = homeDateFormat
        formatter.timeZone = TimeZone(identifier: seoul)
        return formatter
    }()
    
    private static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = apiDateFormat
        formatter.timeZone = TimeZone(identifier: seoul)
        return formatter
    }()
    
    private static let monthAndDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = monthAndDayDateFormat
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
        return homeDateformatter.string(from: date)
    }
    
    static func convertDateFormat(dateString: String?) -> String? {
        guard let dateString = dateString,
              let date = homeDateformatter.date(from: dateString) else {
            return nil
        }
        
        let resultString = apiDateFormatter.string(from: date)
        
        return resultString
    }
    
    static func getPreviousMonth(from date: Date) -> Date {
        return getMonth(from: date, offset: -1)
    }

    static func getNextMonth(from date: Date) -> Date {
        return getMonth(from: date, offset: 1)
    }
    
    static func createDateFromTime(
        hour: Int,
        minute: Int,
        on date: Date = Date()
    ) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0

        return calendar.date(from: dateComponents)
    }
    
    static func toMonthAndDay(date: String) -> String? {
        guard let date = homeDateformatter.date(from: date) else {
            return nil
        }
        return monthAndDayDateFormatter.string(from: date)
    }
    
    private static func getMonth(from date: Date, offset: Int) -> Date {
        guard let date = calendar.date(byAdding: .month, value: offset, to: date) else {
            fatalError("Failed to create date from components. This should not happen.")
        }
        return date
    }
}
