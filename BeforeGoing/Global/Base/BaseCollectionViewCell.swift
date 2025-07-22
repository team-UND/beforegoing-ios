import UIKit

class BaseCollectionViewCell: UICollectionViewCell, ReuseIdentifiable {
    
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
    
    func setStyle() {}
    
    func setUI() {}
    
    func setLayout() {}
}
