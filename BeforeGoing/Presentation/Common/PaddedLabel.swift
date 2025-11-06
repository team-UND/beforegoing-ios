//
//  PaddedLabel.swift
//  BeforeGoing
//
//  Created by APPLE on 11/6/25.
//

import UIKit

final class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
