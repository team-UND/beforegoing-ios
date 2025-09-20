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
    
    func isTokenValid(accessTokenExpirationDate: String, refreshTokenExpirationDate: String) -> Bool {
        guard let accessTokenExpirationDate = toDate(accessTokenExpirationDate),
              let refreshTokenExpirationDate = toDate(refreshTokenExpirationDate) else {
            return false
        }
        
        return !isTokensExpired(
            accessTokenExpirationDate: accessTokenExpirationDate,
            refreshTokenExpirationDate: refreshTokenExpirationDate
        )
    }
    
    func calculateExpirationDate(expiresIn: Int) -> String {
        let currentDate = Date()
        let expirationDate = currentDate.addingTimeInterval(TimeInterval(expiresIn))
        
        return dateFormatter.string(from: expirationDate)
    }
    
    private func toDate(_ dateString: String) -> Date? {
        dateFormatter.date(from: dateString)
    }
    
    private func isTokensExpired(accessTokenExpirationDate: Date, refreshTokenExpirationDate: Date) -> Bool {
        let currentDate = Date()
        return accessTokenExpirationDate < currentDate && refreshTokenExpirationDate < currentDate
    }
}
