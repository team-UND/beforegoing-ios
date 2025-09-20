//
//  LoginViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/10/25.
//

final class LoginViewModel: ViewModeling {
    
    private let kakaoLoginUseCase: KakaoLoginUseCase
    
    init(kakaoLoginUseCase: KakaoLoginUseCase) {
        self.kakaoLoginUseCase = kakaoLoginUseCase
    }
    
    enum Input {
        case kakaoLoginDidTap
        //case appleLoginDidTap
    }
    
    struct Output {
        let result: Bool
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .kakaoLoginDidTap:
            let isRegisteredMember = try await kakaoLoginUseCase.execute(provider: Provider.kakao.rawValue)
            return .init(result: isRegisteredMember)
        }
    }
}
