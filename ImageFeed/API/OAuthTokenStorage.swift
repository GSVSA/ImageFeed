import Foundation

final class OAuthTokenStorage {
    var token: String? {
        get { UserDefaults.standard.string(forKey: "oauthAccessToken") }
        set { UserDefaults.standard.setValue(newValue, forKey: "oauthAccessToken") }
    }
    
    var isAuthorized: Bool { token != nil }
}
