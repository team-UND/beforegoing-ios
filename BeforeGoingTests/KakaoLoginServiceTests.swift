import KakaoSDKCommon
import XCTest
@testable import BeforeGoing

final class KakaoLoginServiceTests: XCTestCase {
    
    private var mockAuthAPI: MockAuthAPI.Type!
    private var mockUserAPI: MockUserAPI!
    private var mockAPIManager: MockAPIManager!
    private var mockKeyChainHelper: MockKeyChainHelper!
    private var kakaoLoginService: KakaoLoginService!
    
    override func setUp() {
        super.setUp()
        mockAuthAPI = MockAuthAPI.self
        mockUserAPI = MockUserAPI()
        mockAPIManager = MockAPIManager()
        mockKeyChainHelper = MockKeyChainHelper()
        
        kakaoLoginService = KakaoLoginService(
            authAPI: mockAuthAPI,
            userAPI: mockUserAPI,
            apiManager: mockAPIManager,
            keyChainHelper: mockKeyChainHelper
        )
    }
    
    override func tearDown() {
        mockAuthAPI = nil
        mockUserAPI = nil
        mockAPIManager = nil
        mockKeyChainHelper = nil
        kakaoLoginService = nil
        super.tearDown()
    }
    
    // MARK: - 로그인 상태 점검
    
    func test_checkLoginStatus_hasNotToken() {
        let expectation = XCTestExpectation(description: "토큰이 없는 경우")
        
        mockAuthAPI.tokenCondition = false
        
        kakaoLoginService.checkLoginStatus { result in
            switch result {
            case .success(let user) :
                XCTAssertEqual(user.nickname, "테스트 유저")
            case .failure(let error) :
                XCTAssertEqual(error, KakaoLoginError.hasNotToken)
            }
            expectation.fulfill()
        }
    }
    
    func test_checkLoginStatus_invalidToken() {
        let expectation = XCTestExpectation(description: "유효하지 않은 토큰 체크")
        
        mockAuthAPI.tokenCondition = true
        mockUserAPI.isErrorOccured = true
        mockUserAPI.isSdkErrorOccured = false
        
        kakaoLoginService.checkLoginStatus { result in
            switch result {
            case .success(let user) :
                XCTAssertEqual(user.nickname, "테스트 유저")
            case .failure(let error) :
                XCTAssertEqual(error, KakaoLoginError.invalidToken)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_checkLoginStatus_performLogin() {
        mockAuthAPI.tokenCondition = true
        mockUserAPI.isErrorOccured = true
        mockUserAPI.isSdkErrorOccured = true
        
        mockUserAPI.accessTokenInfo { info, error in
            XCTAssertTrue(self.mockUserAPI.loginPerformed)
        }
    }
    
    // MARK: - 로그아웃
    
    func test_logout() {
        let cases: [(logoutFailed: Bool, KakaoLoginError?, description: String)] = [
            (false, nil, "로그아웃 성공 테스트"),
            (true, KakaoLoginError.logoutFailed, "로그아웃 실패 테스트")
        ]
        
        for (logoutFailed, logoutError, description) in cases {
            let expectation = XCTestExpectation(description: description)
            
            mockUserAPI.logoutFailed = logoutFailed
            
            kakaoLoginService.performLogout { result in
                switch result {
                case .success() :
                    XCTAssertNil(self.mockKeyChainHelper.savedKey)
                    XCTAssertNil(self.mockKeyChainHelper.savedValue)
                case .failure(let error) :
                    XCTAssertEqual(error, logoutError)
                }
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 1.0)
        }
    }
    
    // MARK: - 서버 통신 (nonce, idToken)
    
    func test_nonceRequest() {
        let cases: [(shouldFailed: Bool, description: String)] = [
            (true, "nonce값 생성 실패 테스트"),
            (false, "nonce값 생성 성공 테스트")
        ]
        
        for (shouldFailed, description) in cases {
            let expectation = XCTestExpectation(description: description)
            mockAPIManager.shouldFailed = shouldFailed
            
            mockAPIManager.request(
                url: APIType.handshake.url,
                method: .post,
                parameters: ["provider": Provider.kakao.rawValue],
                headers: nil,
                responseType: NonceResponseModel.self) { result in
                    switch result {
                    case .success(let data) :
                        XCTAssertEqual(data.nonce, "nonce")
                    case .failure(let error) :
                        XCTAssertEqual(error as! KakaoLoginError, KakaoLoginError.nonceRequestFailed)
                    }
                    expectation.fulfill()
                }
            
            wait(for: [expectation], timeout: 1.0)
        }
    }
    
    func test_idTokenRequest() {
        let cases: [(shouldFailed: Bool, description: String)] = [
            (true, "nonce값 생성 실패 테스트"),
            (false, "nonce값 생성 성공 테스트")
        ]
        
        for (shouldFailed, description) in cases {
            let expectation = XCTestExpectation(description: description)
            
            mockAPIManager.shouldFailed = shouldFailed
            
            mockAPIManager.request(
                url: APIType.login.url,
                method: .post,
                parameters: [
                    "provider": Provider.kakao.rawValue,
                    "id_token": "idToken"
                ],
                headers: nil,
                responseType: AccessTokenResponseModel.self) { result in
                    switch result {
                    case .success(let data) :
                        XCTAssertEqual(data.accessToken, "accessToken")
                    case .failure(let error) :
                        XCTAssertEqual(error as! KakaoLoginError, KakaoLoginError.idTokenMissing)
                    }
                    expectation.fulfill()
                }
            
            wait(for: [expectation], timeout: 1.0)
        }
    }

    // MARK: - 카카오톡 로그인
    
    func test_loginWithKakaoTalk() {
        let cases = [true, false]
        
        for shouldFailed in cases {
            mockUserAPI.shouldFailedWithKakaoLogin = shouldFailed
            
            mockUserAPI.loginWithKakaoTalk(nonce: "nonce") { (oauthToken, error) in
                switch error {
                case .some(let e) :
                    XCTAssertEqual(e as! KakaoLoginError, KakaoLoginError.loginFailed)
                case .none :
                    XCTAssertNotNil(oauthToken)
                }
            }
        }
    }
    
    // MARK: - 사용자 정보 가져오기
    
    func test_fetchUser() {
        let cases = [true, false]
        
        for isFetchUserErrorOccured in cases {
            mockUserAPI.isFetchUserErrorOccured = isFetchUserErrorOccured
            
            mockUserAPI.me { (user, error) in
                if user != nil {
                    if let nickname = user?.kakaoAccount?.profile?.nickname {
                        XCTAssertEqual(nickname, "테스트 유저")
                    }
                    return
                }
                if error != nil {
                    XCTAssertEqual(error, KakaoLoginError.userInfoRequestFailed)
                }
            }
        }
    }
    
    // MARK: - KeyChain key, value 저장
    
    func test_saveKey() {
        mockKeyChainHelper.save("value", forKey: "key")
        
        XCTAssertEqual(mockKeyChainHelper.savedKey, "key")
        XCTAssertEqual(mockKeyChainHelper.savedValue, "value")
    }
}
