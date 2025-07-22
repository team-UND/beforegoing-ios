import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setAction()
        setDelegate()
    }
    
    // 내비게이션바 등 추가적인 UI 작업
    func setView() {}
    
    // 버튼 클릭 등 이벤트 처리
    func setAction() {}
    
    // Delegate, DataSource 등 설정
    func setDelegate() {}
}

extension BaseViewController {
    @objc
    func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
}
