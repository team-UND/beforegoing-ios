//
//  UILabel+.swift
//  BeforeGoing
//
//  Created by APPLE on 8/2/25.
//

import UIKit

extension UILabel {
    
    func makeStrokeTextAttributes() {
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.gray900,
            .foregroundColor: UIColor.gray900,
            .strokeWidth: -3.0,
            .font: UIFont.custom(.brandingH3)
        ]
        self.attributedText = NSAttributedString(
            string: ApproachLiteral.mainTitle.rawValue,
            attributes: strokeTextAttributes
        )
    }
}
