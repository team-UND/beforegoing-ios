import UIKit

extension UIFont {
    
    static func custom(_ style: CustomFont) -> UIFont {
        return UIFont(name: style.weight, size: style.size) ?? .systemFont(ofSize: style.size)
    }
    
    enum CustomFont {
        private static let scaleRatio: CGFloat = max(Screen.height(1), Screen.width(1))
        
        case headingH1, headingH2, headingH3, headingH4, headingH5
        case bodyLGSemiBold, bodyLGMedium, bodyLGRegular
        case bodyMDSemiBold, bodyMDMedium, bodyMDRegular
        case bodySMSemiBold, bodySMMedium, bodySMRegular
        case brandingH4, brandingMedium, brandingRegular
        
        var weight: String {
            switch self {
            case .headingH1, .headingH2, .headingH3, .headingH4, .headingH5, .bodyLGSemiBold, .bodyMDSemiBold, .bodySMSemiBold:
                "Pretendard-SemiBold"
            case .bodyLGMedium, .bodyMDMedium, .bodySMMedium:
                "Pretendard-Medium"
            case .bodyLGRegular, .bodyMDRegular, .bodySMRegular:
                "NotoSansKR-ExtraBold"
            case .brandingH4:
                "SCDream6"
            case .brandingMedium:
                "SCDream5"
            case .brandingRegular:
                "SCDream4"
            }
        }
        
        var size: CGFloat {
            return defaultSize * CustomFont.scaleRatio
        }
        
        private var defaultSize: CGFloat {
            switch self {
            case .headingH1: 36
            case .headingH2: 28
            case .headingH3, .brandingH4: 24
            case .headingH4: 20
            case .headingH5: 18
            case .bodyLGSemiBold, .bodyLGMedium, .bodyLGRegular: 16
            case .bodyMDSemiBold, .bodyMDMedium, .bodyMDRegular, .brandingMedium, .brandingRegular: 14
            case .bodySMSemiBold, .bodySMMedium, .bodySMRegular: 12
            }
        }
    }
}
