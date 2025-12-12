//
//  UserDefaultsService.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

import Foundation

protocol UserDefaultsProtocol {
    func save(_ value: Any, key: UserDefaultsKey) -> Bool
    func load<T>(key: UserDefaultsKey) -> T?
    func delete(key: UserDefaultsKey) -> Bool
}

struct UserDefaultsService: UserDefaultsProtocol {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save(_ value: Any, key: UserDefaultsKey) -> Bool {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        return UserDefaults.standard.value(forKey: key.rawValue) != nil
    }
    
    func save<T: Codable>(_ value: T, key: UserDefaultsKey) -> Bool {
        if let encoded = try? encoder.encode(value) {
            UserDefaults.standard.set(encoded, forKey: key.rawValue)
        }
        return UserDefaults.standard.value(forKey: key.rawValue) != nil
    }
    
    func load<T>(key: UserDefaultsKey) -> T? {
        UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    
    func load<T: Codable>(key: UserDefaultsKey) -> T? {
        if let data = UserDefaults.standard.data(forKey: key.rawValue) {
            return try? decoder.decode(T.self, from: data)
        }
        return nil
    }
    
    func delete(key: UserDefaultsKey) -> Bool {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        return UserDefaults.standard.value(forKey: key.rawValue) == nil
    }
}
