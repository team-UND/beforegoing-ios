final class MockKeyChainHelper: KeyChainProtocol {
    
    var savedKey: String?
    var savedValue: String?
    
    func save(_ value: String, forKey key: String) {
        savedKey = key
        savedValue = value
    }
    
    func delete(key: String) {
        savedKey = nil
        savedValue = nil
    }
    
    func load(key: String) -> String? {
        return savedValue
    }
}
