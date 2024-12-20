import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let thumbImageURL: URL?
    let fullImageURL: URL?
    let isLiked: Bool
}
