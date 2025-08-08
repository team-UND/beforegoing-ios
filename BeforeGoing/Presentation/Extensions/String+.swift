//
//  String+.swift
//  BeforeGoing
//
//  Created by APPLE on 8/6/25.
//

import Foundation

extension String {
    
    var isValidNickname: Bool {
        let regularExpression = "^[가-힣a-zA-Z0-9]{1,8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: self)
    }
    
    func trim(limit: Int) -> String {
        return String(self.prefix(limit))
    }
}
