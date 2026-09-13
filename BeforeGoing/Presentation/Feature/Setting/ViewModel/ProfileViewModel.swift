//
//  ProfileViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 9/13/25.
//

protocol ProfileOutput {}

final class ProfileViewModel: ViewModeling {
    
    private let getMemberNameUseCase: GetMemberNameType
    private let withdrawUseCase: MemberWithdrawType
    
    init(
        getMemberNameUseCase: GetMemberNameType,
        withdrawUseCase: MemberWithdrawType
    ) {
        self.getMemberNameUseCase = getMemberNameUseCase
        self.withdrawUseCase = withdrawUseCase
    }
    
    enum Input {
        case viewWillAppear
        case withdrawButtonDidTap
    }
    
    typealias Output = ProfileOutput
    
    struct MemberNameOutput: ProfileOutput {
        let name: String
    }
    
    struct WithdrawOutput: ProfileOutput {
        let isSucceedWithdraw: Bool
    }
    
    func action(input: Input) async throws -> Output {
        switch input {
        case .viewWillAppear:
            let name = try await getMemberNameUseCase.execute()
            return MemberNameOutput(name: name)
            
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
