//
//  MemberResponseDTO.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

struct MemberResponseDTO: Decodable {
    let id: Int
    let nickname: String
    let kakaoId: String
    let appleId: String
    let createdAt: String
    let updatedAt: String
}

extension MemberResponseDTO {
    func toEntity() -> MemberEntity {
        .init(
            id: id,
            nickname: nickname,
            kakaoID: kakaoId,
            appleID: appleId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
