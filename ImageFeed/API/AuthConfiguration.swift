import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL?
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL?) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }

    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: URLPaths.accessKey,
            secretKey: URLPaths.secretKey,
            redirectURI: URLPaths.redirectURI,
            accessScope: URLPaths.accessScope,
            authURLString: "\(URLPaths.authBaseURLString)\(URLPaths.authPath)",
            defaultBaseURL: URLPaths.defaultBaseURL
        )
    }
}
