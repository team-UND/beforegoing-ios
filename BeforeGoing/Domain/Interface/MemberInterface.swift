//
//  MemberInterface.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

protocol MemberInterface {
    
    var isAppleLogined: Bool? { get }
    
    func updateNickname(nickname: String) async throws
    func withdrawMember() async throws
    func getMemberName() -> String?
    func completeOnboarding() -> Bool
}
