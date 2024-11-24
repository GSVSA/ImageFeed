import Foundation

private struct ProfileResponseBody: Codable {
    let username: String
    let name: String
    let bio: String?
}

final class ProfileService {
    static let shared = ProfileService()

    private let apiService = APIService()
    private(set) var profile: Profile?
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        apiService.fetch(
            getURLRequest(),
            completion
        ) { [weak self] (data: ProfileResponseBody) in
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
    
    private func getURLRequest() -> URLRequest? {
        guard
            let baseUrl = Constants.defaultBaseURL,
            let url = URL(string: Constants.profilePath, relativeTo: baseUrl)
        else {
            assertionFailure("Failed to create URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
