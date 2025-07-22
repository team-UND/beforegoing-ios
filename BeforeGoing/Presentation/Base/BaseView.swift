import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    // 속성을 설정하는 메서드
    func setStyle() {}
    
    // 뷰를 화면에 올리는 메서드
    func setUI() {}
    
    // 레이아웃을 설정하는 메서드
    func setLayout() {}
}
