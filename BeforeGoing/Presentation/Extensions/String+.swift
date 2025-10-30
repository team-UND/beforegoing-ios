//
//  String+.swift
//  BeforeGoing
//
//  Created by APPLE on 8/6/25.
//

import UIKit

extension String {
    
    var isValidNickname: Bool {
        let regularExpression = "^[가-힣a-zA-Z0-9]{1,8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: self)
    }
    
    func trim(limit: Int) -> Self {
        String(self.prefix(limit))
    }
    
    func removeTrailingSpaces() -> String {
        self.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
    
    func removeLeadingSpaces() -> String {
        self.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression)
    }
    
    func customText(
        rangedText: String,
        color: CGColor? = UIColor.warning600.cgColor
    ) -> NSMutableAttributedString {
        guard let color = color else { return NSMutableAttributedString(string: "") }
        
        let attributedString = NSMutableAttributedString(string: self)
        let range = (self as NSString).range(of: rangedText)
        
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
        
        return attributedString
    }
}
