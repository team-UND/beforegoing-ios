//
//  UserDefaultsService.swift
//  BeforeGoing
//
//  Created by APPLE on 9/17/25.
//

import Foundation

protocol UserDefaultsProtocol {
    func save<T: Codable>(_ value: T, key: UserDefaultsKey) -> Bool
    func load<T: Codable>(key: UserDefaultsKey) -> T?
    func delete(key: UserDefaultsKey) -> Bool
}

struct UserDefaultsService: UserDefaultsProtocol {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save<T: Codable>(_ value: T, key: UserDefaultsKey) -> Bool {
        if let encoded = try? encoder.encode(value) {
            UserDefaults.standard.set(encoded, forKey: key.rawValue)
        }
        return UserDefaults.standard.value(forKey: key.rawValue) != nil
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

final class MockUserDefaultsService: UserDefaultsProtocol {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var storage: [UserDefaultsKey: Data] = [:]
    
    func save<T: Codable>(_ value: T, key: UserDefaultsKey) -> Bool {
        guard let encoded = try? encoder.encode(value) else { return false }
        storage[key] = encoded
        return true
    }
    
    func load<T: Codable>(key: UserDefaultsKey) -> T? {
        guard let data = storage[key] else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
    
    func delete(key: UserDefaultsKey) -> Bool {
        guard let _ = storage.removeValue(forKey: key) else { return false }
        return true
    }
    
    func deleteAll() {
        storage.removeAll()
    }
}
