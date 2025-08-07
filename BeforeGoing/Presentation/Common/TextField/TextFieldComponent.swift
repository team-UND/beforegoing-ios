//
//  TextFieldComponent.swift
//  BeforeGoing
//
//  Created by APPLE on 7/25/25.
//

import UIKit

struct TextFieldComponent {
    let backgroundColor: UIColor
    let width: CGFloat
    let height: CGFloat
    var borderColor: CGColor = UIColor.clear.cgColor
    var borderWidth: CGFloat = 0
    let font: UIFont = .custom(.bodyLGMedium)
    let cornerRadius: CGFloat = 20
    let autocapitalizationType: UITextAutocapitalizationType = .none
}
