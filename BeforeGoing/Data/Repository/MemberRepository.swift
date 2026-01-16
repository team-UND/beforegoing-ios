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
    
    var isAppleLogined: Bool? {
        guard let provider: String = userDefaultsService.load(key: .provider) else {
            return nil
        }
        
        if provider == Provider.apple.rawValue {
            return true
        }
        return false
    }
    
    func getMemberName() async throws -> MemberNameEntity {
        do {
            let memberName = try await fetchMemberName()
            return memberName
        } catch {
            return .stub()
        }
    }
    
    func updateNickname(nickname: String) async throws {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return
        }
        
        let requestDTO = updateNicknameRequestMapper.map(nickname)
        let _ = try await networkService.request(
            endPoint: MemberAPI.updateNickname(accessToken: accessToken, dto: requestDTO),
            responseType: MemberResponseDTO.self
        )
    }
    
    func withdrawMember() async throws {
        guard let accessToken = keyChainService.load(key: .accessToken),
              let provider: String = userDefaultsService.load(key: .provider) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return
        }
        
        do {
            try await networkService.request(endPoint: MemberAPI.withdraw(accessToken: accessToken))
            removeMemberInfo(provider: provider)
            removeNotifications()
        } catch {
            throw BeforeGoingError.withdrawFailed
        }
    }
    
    private func fetchMemberName() async throws -> MemberNameEntity {
        guard let accessToken = keyChainService.load(key: .accessToken) else {
            BeforeGoingLogger.error(BeforeGoingError.accessTokenMissing)
            return .stub()
        }
        
        let fetchedName = try await networkService.requestString(
            endPoint: MemberAPI.fetchMemberName(accessToken: accessToken)
        )
        
        return .init(memberName: fetchedName)
    }
    
    private func removeMemberInfo(provider: String) {
        removeKeyChainInfo()
        removeUserDefaultsInfo(provider: provider)
    }
    
    private func removeNotifications() {
        NotificationManager.shared.removeAllNotifications()
    }
    
    private func removeKeyChainInfo() {
        for key in KeyChainKey.allCases {
            keyChainService.delete(key: key)
        }
    }
    
    private func removeUserDefaultsInfo(provider: String) {
        UserDefaultsKey.allCases
            .forEach {
                let _ = userDefaultsService.delete(key: $0)
            }
    }
}
