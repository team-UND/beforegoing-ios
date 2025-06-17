import UIKit
import SnapKit
import Then

final class ExampleLoginView: BaseView {
    
    let kakaoLoginButton = UIButton()
    let logoutButton = UIButton()
    let stateLabel = UILabel()
    
    override func setStyle() {
        kakaoLoginButton.do {
            $0.setImage(.kakaoLogin, for: .normal)
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 5
        }
        
        logoutButton.do {
            $0.backgroundColor = .white
            $0.setTitle("로그아웃", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.cornerRadius = 4
        }
        
        stateLabel.do {
            $0.backgroundColor = .gray
            $0.textAlignment = .center
            $0.layer.cornerRadius = 4
        }
    }
    
    override func setUI() {
        addSubviews(kakaoLoginButton, logoutButton, stateLabel)
    }
    
    override func setLayout() {
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(80)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(50)
        }
        
        stateLabel.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
}
