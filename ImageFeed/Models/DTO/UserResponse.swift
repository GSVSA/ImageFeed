import Foundation

struct ProfileImageResponse: Codable {
    let small: URL
}

struct UserResponse: Codable {
    let profileImage: ProfileImageResponse
}
