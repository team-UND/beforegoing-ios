//
//  ListItemProtocol.swift
//  BeforeGoing
//
//  Created by APPLE on 8/19/25.
//

import UIKit

protocol ListItemProtocol: BaseView {
    var checkBoxView: UIView { get }
    var checkBox: CheckBox { get }
    
    func updateText(_ text: String)
}
