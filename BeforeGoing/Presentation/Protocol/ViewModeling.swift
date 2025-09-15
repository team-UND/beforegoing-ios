//
//  ViewModeling.swift
//  BeforeGoing
//
//  Created by APPLE on 9/10/25.
//

protocol ViewModeling {
    
    associatedtype Input
    associatedtype Output
    
    func action(input: Input) async throws -> Output
}
