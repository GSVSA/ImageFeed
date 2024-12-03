import Foundation

enum URLPaths {
    static let defaultBaseURL = URL(string: "https://api.unsplash.com/")
    static let authBaseURL = "https://unsplash.com/"
    static let accessKey = "3YAdabLLdWUIbcFhnv-iit2anwOjydpy1S21JQ1t86M"
    static let secretKey = "v0zUPOWxlNw7XEbGjlcnbU4DRWsh3nF29Br7plvfEP0"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let tokenPath = "/oauth/token"
    static let authPath = "/oauth/authorize"
    static let profilePath = "/me"
    static let profileImagePath = "/users"
    static let photosPath = "/photos"

    static func likePath(for id: String) -> String {
        "\(photosPath)/\(id)/like"
    }
}
