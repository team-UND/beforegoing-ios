//
//  ProfileViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/13/25.
//

protocol ProfileOutput {}

final class ProfileViewModel: ViewModeling {
    
    private let getMemberNameUseCase: GetMemberNameType
    private let logoutUseCase: LogoutType
    private let withdrawUseCase: MemberWithdrawType
    
    init(
        getMemberNameUseCase: GetMemberNameType,
        logoutUseCase: LogoutType,
        withdrawUseCase: MemberWithdrawType
    ) {
        self.getMemberNameUseCase = getMemberNameUseCase
        self.logoutUseCase = logoutUseCase
        self.withdrawUseCase = withdrawUseCase
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
            let name = try await getMemberNameUseCase.execute()
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
            do {
                try await withdrawUseCase.execute()
                return WithdrawOutput(isSucceedWithdraw: true)
            } catch(let error) {
                BeforeGoingLogger.error(error)
                return WithdrawOutput(isSucceedWithdraw: false)
            }
        }
    }
}
