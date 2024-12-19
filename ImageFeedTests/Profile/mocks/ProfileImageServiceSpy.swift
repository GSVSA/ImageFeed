import Foundation
@testable import ImageFeed

final class ProfileImageServiceSpy: ProfileImageServiceProtocol {
    let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderSpyDidChange")
    static let shared = ProfileImageServiceSpy()
    private(set) var avatarUrl: String? = "http://example.com/avatar.jpg"
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, any Error>) -> Void) {}
    
    func reset() {}
}
