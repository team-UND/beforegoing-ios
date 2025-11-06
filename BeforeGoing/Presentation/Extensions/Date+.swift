//
//  Date+.swift
//  BeforeGoing
//
//  Created by APPLE on 10/27/25.
//

import Foundation

extension Date {
    
    static func ==(_ lhs: Date, _ rhs: Date) -> Bool {
        let calendar = Calendar.current
        let left = calendar.dateComponents([.year, .month, .day], from: lhs)
        let right = calendar.dateComponents([.year, .month, .day], from: rhs)
        
        return left == right
    }
}
