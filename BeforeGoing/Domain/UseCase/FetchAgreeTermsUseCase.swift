//
//  FetchAgreementTermsUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/18/25.
//

struct FetchAgreeTermsUseCase {
    
    private let repository: TermsInterface
    
    init(repository: TermsInterface) {
        self.repository = repository
    }
    
    func execute() async throws -> TermsEntity? {
        guard let result = try await repository.getAgreementTerms() else {
            return nil
        }
        return result
    }
}
