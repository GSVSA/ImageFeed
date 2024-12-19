import Foundation

protocol ProfileServiceProtocol {
    var profile: Profile? { get }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
    func reset()
}

final class ProfileService: ProfileServiceProtocol {
    static let shared = ProfileService()

    private let apiService = APIService()
    private(set) var profile: Profile?
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        apiService.fetch(
            getURLRequest(),
            completion
        ) { [weak self] (data: ProfileResponse) in
            let profileData = Profile(
                username: data.username,
                name: data.name,
                loginName: "@" + data.username,
                bio: data.bio
            )
            self?.profile = profileData
            return profileData
        }
    }
    
    func reset() {
        profile = nil
    }
    
    private func getURLRequest() -> URLRequest? {
        guard
            let baseUrl = URLPaths.defaultBaseURL,
            let url = URL(string: URLPaths.profilePath, relativeTo: baseUrl)
        else {
            assertionFailure("Failed to create URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
