//
//  SaveIsCompletedOnboardingUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 11/13/25.
//

protocol SaveOnboardingCompletedType {
    func saveOnboardingCompleted() -> Bool
}

struct SaveOnboardingCompletedUseCase: SaveOnboardingCompletedType {
    
    private let repository: MemberInterface
    
    init(repository: MemberInterface) {
        self.repository = repository
    }
    
    func saveOnboardingCompleted() -> Bool {
        repository.completeOnboarding()
    }
}
