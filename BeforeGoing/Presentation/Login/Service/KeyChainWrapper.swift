protocol KeyChainProtocol {
    func save(_ value: String, forKey key: String)
    func delete(key: String)
}

struct KeyChainWrapper: KeyChainProtocol {
    func save(_ value: String, forKey key: String) {
        KeyChainHelper.save(value, forKey: key)
    }
    
    func delete(key: String) {
        KeyChainHelper.delete(key: key)
    }
}
