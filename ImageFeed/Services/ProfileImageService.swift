import Foundation

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
        ) { [weak self] (data: UserResponse) in
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
    
    func reset() {
        avatarUrl = nil
    }
    
    private func getURLRequest(_ username: String) -> URLRequest? {
        guard
            let baseUrl = URLPaths.defaultBaseURL,
            let url = URL(string: "\(URLPaths.profileImagePath)/\(username)", relativeTo: baseUrl)
        else {
            assertionFailure("Failed to create URL")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
