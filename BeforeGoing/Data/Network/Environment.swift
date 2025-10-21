import Foundation

enum Environment {
    
    static var baseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String, !url.isEmpty else {
            fatalError("BASE_URL not found in Info.plist — check .xcconfig and target config")
        }
        return url
    }
}
