//
//  OnboardingViewModel.swift
//  BeforeGoing
//
//  Created by APPLE on 11/13/25.
//

final class OnboardingViewModel: ViewModeling {
    
    private let useCase: SaveOnboardingCompletedType
    
    init(useCase: SaveOnboardingCompletedType) {
        self.useCase = useCase
    }
    
    enum Input {
        case startButtonDidTap
    }
    
    struct Output {
        let isCompletedOnboarding: Bool
    }
    
    func action(input: Input) -> Output {
        switch input {
        case .startButtonDidTap:
            let isSaved = useCase.saveOnboardingCompleted()
            return .init(isCompletedOnboarding: isSaved)
        }
    }
}
