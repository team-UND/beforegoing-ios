//
//  MemberNameEntity.swift
//  BeforeGoing
//
//  Created by APPLE on 1/12/26.
//

struct MemberNameEntity {
    let memberName: String
}

extension MemberNameEntity {
    static func stub() -> Self {
        return .init(memberName: "워리")
    }
}
