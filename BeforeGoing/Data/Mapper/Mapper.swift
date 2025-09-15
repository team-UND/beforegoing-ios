//
//  Mapper.swift
//  BeforeGoing
//
//  Created by APPLE on 9/11/25.
//

protocol Mapper {
    
    associatedtype Input
    associatedtype Output
    
    func map(_ input: Input) -> Output
}
