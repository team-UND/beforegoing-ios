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
    
    func register<T>(type: T.Type, closure: @escaping (DIContainer) -> Any) {
        let key = createKey(T.self)
        storage[key] = closure
    }
    
    func resolve<T>() -> T? {
        let key = createKey(T.self)
        guard let object = storage[key] as? T else {
            return nil
        }
        return object
    }
    
    func resolve<T>(type: T.Type) -> T? {
        let key = createKey(T.self)
        guard let object = storage[key] as? (DIContainer) -> Any else {
            return nil
        }
        return object(self) as? T
    }
    
    private func createKey<T>(_ object: T.Type) -> String {
        String(describing: object)
    }
}
