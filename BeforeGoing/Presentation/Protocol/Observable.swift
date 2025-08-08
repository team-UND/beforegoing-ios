//
//  Observable.swift
//  BeforeGoing
//
//  Created by APPLE on 8/5/25.
//

final class Observable<T> {
    
    var data: T {
        didSet {
            onChange?(data)
        }
    }
    
    var onChange: ((T) -> Void)?
    
    init(_ data: T) {
        self.data = data
    }
    
    func bind(callback: @escaping (T) -> Void) {
        self.onChange = callback
    }
}
