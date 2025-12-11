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
    private static let seoulTimeZoneIdentifier = "Asia/Seoul"
    
    private static var seoulTimeZone: TimeZone? {
        return TimeZone(identifier: seoulTimeZoneIdentifier)
    }
    
    private static var seoulCalendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        if let tz = seoulTimeZone {
            cal.timeZone = tz
        }
        return cal
    }
    
    private static let homeDateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = homeDateFormat
        formatter.timeZone = seoulTimeZone
        return formatter
    }()
    
    private static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = apiDateFormat
        formatter.timeZone = seoulTimeZone
        return formatter
    }()
    
    private static let monthAndDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = monthAndDayDateFormat
        formatter.timeZone = seoulTimeZone
        return formatter
    }()
    
    static func getCurrentDate() -> Date {
        let now = Date()
        let components = seoulCalendar.dateComponents([.year, .month, .day], from: now)
        guard let date = seoulCalendar.date(from: components) else {
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
    
    static func toDate(dateString: String) -> Date? {
        return homeDateformatter.date(from: dateString)
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
        let current = seoulCalendar.dateComponents([.year, .month, .day], from: date)
        
        var dateComponents = DateComponents()
        dateComponents.timeZone = seoulTimeZone
        dateComponents.year = current.year
        dateComponents.month = current.month
        dateComponents.day = current.day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
        
        let date = seoulCalendar.date(from: dateComponents)
        return date
    }
    
    static func toMonthAndDay(date: String) -> String? {
        guard let date = homeDateformatter.date(from: date) else {
            return nil
        }
        return monthAndDayDateFormatter.string(from: date)
    }
    
    static func toMonthAndDay(date: Date) -> String? {
        return monthAndDayDateFormatter.string(from: date)
    }
    
    static func isTwoMonthsApart(from startDate: Date, to endDate: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: startDate, to: endDate)
        
        return (components.month ?? 0) > 1
    }
    
    static func isWithinThreeDaysFromToday(startDate: Date, endDate: Date) -> Bool {
        let diffComponents = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        guard  let diff = diffComponents.day else {
            return false
        }
        return diff >= 0 && diff <= 3
    }
    
    private static func getMonth(from date: Date, offset: Int) -> Date {
        guard let date = seoulCalendar.date(byAdding: .month, value: offset, to: date) else {
            fatalError("Failed to create date from components. This should not happen.")
        }
        return date
    }
}
