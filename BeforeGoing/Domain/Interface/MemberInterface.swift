//
//  MemberInterface.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

protocol MemberInterface {
    
    func updateNickname(nickname: String) async throws
    func withdrawMember() async throws
    func getMemberName() -> String?
}
