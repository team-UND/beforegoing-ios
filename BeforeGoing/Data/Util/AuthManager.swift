//
//  AuthManager.swift
//  BeforeGoing
//
//  Created by APPLE on 12/12/25.
//

import UserNotifications

final class AuthManager {
    
    static let shared = AuthManager()
    
    private let keyChainService: KeyChainService
    private let tokenValidator: TokenValidator
    
    var isAutoLoginEnabled: Bool {
        guard let accessTokenExpirationDate: String =  keyChainService.load(key: .accessTokenExpirationDate),
              let refreshTokenExpirationDate: String = keyChainService.load(key: .refreshTokenExpirationDate) else {
            return false
        }
        
        let isExpiredAccessToken = tokenValidator.isAccessTokenValid(expirationDate: accessTokenExpirationDate)
        let isExpiredRefreshToken = tokenValidator.isRefreshTokenValid(expirationDate: refreshTokenExpirationDate)
        
        if !isExpiredAccessToken && !isExpiredRefreshToken {
            return false
        }
        
        return true
    }
    
    var pendingNotificationRequest: UNNotificationRequest?
    
    private init() {
        self.keyChainService = KeyChainService()
        self.tokenValidator = TokenValidator()
    }
}
