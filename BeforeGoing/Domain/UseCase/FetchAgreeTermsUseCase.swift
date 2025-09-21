//
//  FetchAgreementTermsUseCase.swift
//  BeforeGoing
//
//  Created by APPLE on 9/18/25.
//

protocol FetchAgreeTermsType {
    func execute() async throws -> TermsEntity?
}

struct FetchAgreeTermsUseCase: FetchAgreeTermsType {
    
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

struct MockFetchAgreeTermsUseCase: FetchAgreeTermsType {
    
    func execute() -> TermsEntity? {
        return .stub()
    }
}
