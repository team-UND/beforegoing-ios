//
//  TokenValidator.swift
//  BeforeGoing
//
//  Created by APPLE on 9/20/25.
//

import Foundation

struct TokenValidator {
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    func isAccessTokenValid(expirationDate: String) -> Bool {
        guard let date = toDate(expirationDate) else {
            return false
        }
        return date > Date()
    }
    
    func isRefreshTokenValid(expirationDate: String) -> Bool {
        guard let date = toDate(expirationDate) else {
            return false
        }
        return date > Date()
    }
    
    func calculateExpirationDate(expiresIn: Int) -> String {
        let currentDate = Date()
        let expirationDate = currentDate.addingTimeInterval(TimeInterval(expiresIn))
        
        return dateFormatter.string(from: expirationDate)
    }
    
    private func toDate(_ dateString: String) -> Date? {
        dateFormatter.date(from: dateString)
    }
}
