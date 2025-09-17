final class MockKeyChainHelper: KeyChainProtocol {
    
    var savedKey: KeyChainKey?
    var savedValue: String?
    
    func save(_ value: String, forKey key: KeyChainKey) {
        savedKey = key
        savedValue = value
    }
    
    func delete(key: KeyChainKey) {
        savedKey = nil
        savedValue = nil
    }
    
    func load(key: KeyChainKey) -> String? {
        return savedValue
    }
}
