import Foundation
@testable import ImageFeed

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    let didChangeNotification = Notification.Name(rawValue: "ImagesListProviderSpyDidChange")
    var nextPageFetched = false
    var likeChanged = false
    
    static let shared = ImagesListServiceSpy()
    
    private(set) var photos: [Photo] = photosStub
    
    private init() {}
    
    func fetchPhotosNextPage() {
        nextPageFetched = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        likeChanged = true
    }
    
    func reset() {
    }
    
    func cleanUpTests() {
        nextPageFetched = false
        likeChanged = false
    }
}
