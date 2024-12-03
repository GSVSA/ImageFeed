import Foundation
import SwiftKeychainWrapper

final class OAuthTokenStorage {
    private let tokenKey = "oauthAccessToken"
    
    var token: String? {
        get { KeychainWrapper.standard.string(forKey: tokenKey) }
        set {
            guard let newValue else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: tokenKey) }
    }
    
    var isAuthorized: Bool { token != nil }
    
    func reset() {
        token = nil
    }
}
