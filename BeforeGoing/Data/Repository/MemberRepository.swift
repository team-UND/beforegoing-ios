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
        guard let name: String? = userDefaultsService.load(key: .memberName) else {
            return nil
        }
        return name
    }
    
    func updateNickname(nickname: String) async throws {
        guard let accessToken = keyChainService.load(key: .accessToken) else { return }
        
        let requestDTO = updateNicknameRequestMapper.map(nickname)
        let responseDTO = try await networkService.request(
            endPoint: MemberAPI.updateNickname(accessToken: accessToken, dto: requestDTO),
            responseType: MemberResponseDTO.self
        )
        let _ = userDefaultsService.save(responseDTO.nickname, key: .memberName)
    }
    
    func withdrawMember() async throws {
        guard let accessToken = keyChainService.load(key: .accessToken) else { return }
        
        try await networkService.request(endPoint: MemberAPI.withdraw(accessToken: accessToken))
        removeMemberInfo()
    }
    
    private func removeMemberInfo() {
        removeKeyChainInfo()
        removeUserDefaultsInfo()
    }
    
    private func removeKeyChainInfo() {
        for key in KeyChainKey.allCases {
            keyChainService.delete(key: key)
        }
    }
    
    private func removeUserDefaultsInfo() {
        for key in UserDefaultsKey.allCases {
            let _ = userDefaultsService.delete(key: key)
        }
    }
}
