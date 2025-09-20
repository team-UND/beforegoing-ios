protocol KeyChainProtocol {
    func save(_ value: String, forKey key: KeyChainKey)
    func delete(key: KeyChainKey)
    func load(key: KeyChainKey) -> String?
}

struct KeyChainService: KeyChainProtocol {
    func save(_ value: String, forKey key: KeyChainKey) {
        KeyChainHelper.save(value, forKey: key.rawValue)
    }
    
    func delete(key: KeyChainKey) {
        KeyChainHelper.delete(key: key.rawValue)
    }
    
    func load(key: KeyChainKey) -> String? {
        return KeyChainHelper.load(key: key.rawValue)
    }
}
