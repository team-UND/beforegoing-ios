import Foundation

enum Environment {
    static let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as! String
}
