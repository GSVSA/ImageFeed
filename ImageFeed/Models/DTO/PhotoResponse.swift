import Foundation

struct UrlsResponse: Codable {
    let thumb: String
    let full: String
}

struct PhotoResponse: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let likedByUser: Bool
    let urls: UrlsResponse
}
