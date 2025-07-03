import UIKit
import KakaoSDKAuth
import KakaoSDKUser

final class ExampleLoginViewController: BaseViewController {
    
    private let loginView = ExampleLoginView()
    private let kakaoLoginService = KakaoLoginService(
        authAPI: AuthAPIWrapper.self,
        userAPI: UserAPIWrapper(),
        apiManager: APIManager.shared,
        keyChainHelper: KeyChainWrapper()
    )
    
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
        loginView.nonceButton.addTarget(self, action: #selector(nonceButtonDidTap), for: .touchUpInside)
        loginView.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonDidTap), for: .touchUpInside)
        loginView.logoutButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
        loginView.helloButton.addTarget(self, action: #selector(helloButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func nonceButtonDidTap() {
        kakaoLoginService.performLogin { result in
            switch result {
            case .success(let _) :
                print("nonce 값을 받았습니다")
            case .failure(let _) :
                print("nonce 값을 받지 못했습니다")
            }
        }
    }
    
    @objc
    private func kakaoLoginButtonDidTap() {
        kakaoLoginService.loginWithKakao { result in
            switch result {
            case .success:
                self.loginView.stateLabel.text = "로그인에 성공했습니다 \(KeyChainHelper.load(key: KeyChainKey.accessToken.rawValue))"
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
    
    @objc
    private func helloButtonDidTap() {
        kakaoLoginService.hello { result in
            switch result {
            case .some(let message) :
                self.loginView.stateLabel.text = message
            case .none :
                self.loginView.stateLabel.text = "None"
            }
        }
    }
    
    private func handleError(_ error: KakaoLoginError) {
        switch error {
        case .hasNotToken:
            showAlert("토큰이 유효하지 않습니다.")
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
