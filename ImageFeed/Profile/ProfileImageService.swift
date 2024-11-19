import Foundation

private struct ProfileImage: Codable {
    let small: URL
}

private struct UserResult: Codable {
    let profileImage: ProfileImage
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let apiService = APIService()
    private(set) var avatarUrl: String?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        apiService.fetch(
            getURLRequest(username),
            completion
        ) { [weak self] (data: UserResult) in
            let avatarUrl = data.profileImage.small.absoluteString
            self?.avatarUrl = avatarUrl
            NotificationCenter.default.post(
                name: ProfileImageService.didChangeNotification,
                object: self,
                userInfo: ["URL": avatarUrl]
            )
            return avatarUrl
         }
    }
    
    private func getURLRequest(_ username: String) -> URLRequest? {
        guard
            let baseUrl = Constants.defaultBaseURL,
            let url = URL(string: "\(Constants.profileImagePath)/\(username)", relativeTo: baseUrl)
        else {
            assertionFailure("Failed to create URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
