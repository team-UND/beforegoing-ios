//
//  ProfileViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/13/25.
//

protocol ProfileOutput {}

final class ProfileViewModel: ViewModeling {
    
    private let getMemberNameUseCase: GetMemberNameUseCase
    private let logoutUseCase: LogoutUseCase
    
    init(getMemberNameUseCase: GetMemberNameUseCase, logoutUseCase: LogoutUseCase) {
        self.getMemberNameUseCase = getMemberNameUseCase
        self.logoutUseCase = logoutUseCase
    }
    
    enum Input {
        case viewWillAppear
        case logoutButtonDidTap
        case withdrawButtonDidTap
    }
    
    typealias Output = ProfileOutput
    
    struct MemberNameOutput: ProfileOutput {
        let name: String
    }
    
    struct LogoutOutput: ProfileOutput {
        let isSucceedLogout: Bool
    }
    
    struct WithdrawOutput: ProfileOutput {
        let isSucceedWithdraw: Bool
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .viewWillAppear:
            let name = getMemberNameUseCase.execute()
            return MemberNameOutput(name: name)
        case .logoutButtonDidTap:
            do {
                try await logoutUseCase.execute()
                return LogoutOutput(isSucceedLogout: true)
            } catch(let error) {
                BeforeGoingLogger.error(error)
                return LogoutOutput(isSucceedLogout: false)
            }
        case .withdrawButtonDidTap:
            return WithdrawOutput(isSucceedWithdraw: true)
        }
    }
}
