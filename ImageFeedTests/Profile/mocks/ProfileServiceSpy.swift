import Foundation
@testable import ImageFeed

final class ProfileServiceSpy: ProfileServiceProtocol {
    static let shared = ProfileServiceSpy()

    private(set) var profile: Profile? = Profile(username: "johndaw", name: "John Daw", loginName: "@johndaw", bio: nil)
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {}
    
    func reset() {}
}
