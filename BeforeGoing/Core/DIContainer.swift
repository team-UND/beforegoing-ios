//
//  DIContainer.swift
//  ByeBoo-iOS
//
//  Created by apple on 9/14/25.
//

import Foundation

final class DIContainer {
    
    static let shared = DIContainer()
    private init() {}
    
    private var storage: [String : Any] = [:]
    
    func register<T>(_ object: T) {
        let key = createKey(T.self)
        storage[key] = object
    }
    
    func resolve<T>() -> T? {
        let key = createKey(T.self)
        guard let object = storage[key] as? T else {
            return nil
        }
        return object
    }
    
    private func createKey<T>(_ object: T.Type) -> String {
        String(describing: object)
    }
}
