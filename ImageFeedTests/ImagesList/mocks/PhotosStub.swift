import Foundation
@testable import ImageFeed

let photosStub: [Photo] = [
    Photo(
        id: "1",
        size: .init(width: 200, height: 200),
        createdAt: nil,
        thumbImageURL: URL(string: "http://example.com/thumb/1.jpg"),
        fullImageURL: URL(string: "http://example.com/full/1.jpg"),
        isLiked: false
    ),
    Photo(
        id: "2",
        size: .init(width: 150, height: 100),
        createdAt: nil,
        thumbImageURL: URL(string: "http://example.com/thumb/2.jpg"),
        fullImageURL: URL(string: "http://example.com/full/2.jpg"),
        isLiked: false
    ),
    Photo(
        id: "3",
        size: .init(width: 150, height: 400),
        createdAt: nil,
        thumbImageURL: URL(string: "http://example.com/thumb/3.jpg"),
        fullImageURL: URL(string: "http://example.com/full/3.jpg"),
        isLiked: true
    ),
    Photo(
        id: "4",
        size: .init(width: 100, height: 400),
        createdAt: nil,
        thumbImageURL: URL(string: "http://example.com/thumb/4.jpg"),
        fullImageURL: URL(string: "http://example.com/full/4.jpg"),
        isLiked: true
    ),
    Photo(
        id: "5",
        size: .init(width: 200, height: 100),
        createdAt: nil,
        thumbImageURL: URL(string: "http://example.com/thumb/5.jpg"),
        fullImageURL: URL(string: "http://example.com/full/5.jpg"),
        isLiked: false
    ),
]
