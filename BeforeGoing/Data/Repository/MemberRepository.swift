//
//  MemberRepository.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

struct MemberRepository: MemberInterface {
    
    private let networkService: NetworkService
    private let keyChainService: KeyChainService
    private let updateNicknameRequestMapper: UpdateNicknameRequestMapper
    
    init(
        networkService: NetworkService,
        keyChainService: KeyChainService,
        updateNicknameRequestMapper: UpdateNicknameRequestMapper
    ) {
        self.networkService = networkService
        self.keyChainService = keyChainService
        self.updateNicknameRequestMapper = updateNicknameRequestMapper
    }
    
    func updateNickname(nickname: String) async throws {
        let requestDTO = updateNicknameRequestMapper.map(nickname)
        let accessToken = keyChainService.load(key: "accessToken") ?? ""
        let responseDTO = try await networkService.request(
            endPoint: MemberAPI.updateNickname(accessToken: accessToken, dto: requestDTO),
            responseType: MemberResponseDTO.self
        )
        // UserDefault에 저장
    }
}
