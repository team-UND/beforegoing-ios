//
//  MemberRepository.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

struct MemberRepository: MemberInterface {
    
    private let networkService: NetworkService
    private let keyChainService: KeyChainService
    private let userDefaultsService: UserDefaultsService
    private let updateNicknameRequestMapper: UpdateNicknameRequestMapper
    
    init(
        networkService: NetworkService,
        keyChainService: KeyChainService,
        userDefaultsService: UserDefaultsService,
        updateNicknameRequestMapper: UpdateNicknameRequestMapper
    ) {
        self.networkService = networkService
        self.keyChainService = keyChainService
        self.userDefaultsService = userDefaultsService
        self.updateNicknameRequestMapper = updateNicknameRequestMapper
    }
    
    func getMemberName() -> String? {
        guard let provider: String = userDefaultsService.load(key: .provider) else {
            return nil
        }
        
        switch provider {
        case Provider.kakao.rawValue:
            return userDefaultsService.load(key: .kakaoMemberName)
        case Provider.apple.rawValue:
            return userDefaultsService.load(key: .appleMemberName)
        default:
            return nil
        }
    }
    
    func updateNickname(nickname: String) async throws {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return
        }
        guard let provider: String = userDefaultsService.load(key: .provider) else {
            return
        }
        
        let requestDTO = updateNicknameRequestMapper.map(nickname)
        let responseDTO = try await networkService.request(
            endPoint: MemberAPI.updateNickname(accessToken: accessToken, dto: requestDTO),
            responseType: MemberResponseDTO.self
        )
        
        if provider == Provider.apple.rawValue {
            let _ = userDefaultsService.save(responseDTO.nickname, key: .appleMemberName)
        }
        if provider == Provider.kakao.rawValue {
            let _ = userDefaultsService.save(responseDTO.nickname, key: .kakaoMemberName)
        }
    }
    
    func withdrawMember() async throws {
        guard let accessToken = keyChainService.load(key: .accessToken),
        let provider: String = userDefaultsService.load(key: .provider) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return
        }
        
        try await networkService.request(endPoint: MemberAPI.withdraw(accessToken: accessToken))
        
        removeMemberInfo(provider: provider)
    }
    
    func completeOnboarding() -> Bool {
        let isSaved = userDefaultsService.save(true, key: .isCompletedOnboarding)
        return isSaved
    }
    
    private func removeMemberInfo(provider: String) {
        removeKeyChainInfo()
        removeUserDefaultsInfo(provider: provider)
    }
    
    private func removeKeyChainInfo() {
        for key in KeyChainKey.allCases {
            keyChainService.delete(key: key)
        }
    }
    
    private func removeUserDefaultsInfo(provider: String) {
        let excludedKey: UserDefaultsKey? = {
            switch provider {
            case Provider.kakao.rawValue: return .appleMemberName
            case Provider.apple.rawValue: return .kakaoMemberName
            default: return nil
            }
        }()

        UserDefaultsKey.allCases
            .filter { $0 != excludedKey }
            .forEach { let _ = userDefaultsService.delete(key: $0) }
    }
}
