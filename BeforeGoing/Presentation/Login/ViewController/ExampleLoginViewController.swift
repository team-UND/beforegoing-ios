import UIKit

final class ExampleLoginViewController: BaseViewController {
    
    private let loginView = ExampleLoginView()
    private let kakaoLoginService = KakaoLoginService()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kakaoLoginService.checkLoginStatus { result in
            switch result {
            case .success(let user):
                self.loginView.stateLabel.text = "\(user.nickname)님 환영해요"
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    override func setAction() {
        loginView.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonDidTap), for: .touchUpInside)
        loginView.logoutButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func kakaoLoginButtonDidTap() {
        kakaoLoginService.performLogin { result in
            switch result {
            case .success:
                self.loginView.stateLabel.text = "로그인에 성공했습니다"
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    @objc
    private func logoutButtonDidTap() {
        kakaoLoginService.performLogout { result in
            switch result {
            case .success:
                self.loginView.stateLabel.text = "로그아웃에 성공했습니다"
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    private func handleError(_ error: KakaoLoginError) {
        switch error {
        case .invalidToken:
            showAlert("토큰이 유효하지 않습니다.")
        case .loginFailed:
            showAlert("카카오 로그인에 실패했어요.")
        case .idTokenMissing:
            showAlert("ID 토큰을 받아오지 못했어요.")
        case .logoutFailed:
            showAlert("카카오 로그아웃에 실패했어요.")
        case .nonceRequestFailed:
            showAlert("서버에서 nonce를 받아오지 못했어요.")
        case .userInfoRequestFailed:
            showAlert("사용자 정보를 가져오지 못했어요.")
        case .serverAuthFailed:
            showAlert("서버 인증에 실패했어요.")
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "로그인 오류", message: message, preferredStyle: .alert)
        let success = UIAlertAction(title: "확인", style: .default) { _ in }
        alert.addAction(success)
        present(alert, animated: true, completion: nil)
    }
}
