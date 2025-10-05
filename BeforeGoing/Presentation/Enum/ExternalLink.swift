//
//  ExternalLink.swift
//  BeforeGoing
//
//  Created by APPLE on 10/4/25.
//

import SafariServices
import UIKit

enum ExternalLink: String {
    
    case support = "https://www.instagram.com/before._.going?igsh=ZzBpY2ZtMHIzbGw="
    case privacy = "https://fluffy-nectarine-129.notion.site/2824ff02f66080b290c6ce933b8759d7?source=copy_link"
    case term = "https://fluffy-nectarine-129.notion.site/2824ff02f6608029a52ed13a25059f97?source=copy_link"
    
    func openURL(for rootViewController: UIViewController) {
        guard let url = URL(string: self.rawValue) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .fullScreen
        rootViewController.present(safariVC, animated: true)
    }
}
