import Foundation
import XCTest
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

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled = false

    var view: ImagesListViewControllerProtocol?
    private(set) var photos: [Photo] = []
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func getPhoto(at index: Int) -> Photo {
        photos[index]
    }
    
    func getConfigForCell(at index: Int) -> ImageCellConfig? {
        let imageInfo = getPhoto(at: index)
        guard let imageURL = imageInfo.thumbImageURL else { return nil }
        
        return ImageCellConfig(
            imageURL: imageURL,
            isLiked: imageInfo.isLiked,
            createdDate: nil
        )
    }
    
    func fetchNextPageIfAvailable(at index: Int) {}
    
    func didTapLike(at index: Int, completion: @escaping (Result<Bool, Error>) -> Void) {}
    
    func cleanUpTests() {
        viewDidLoadCalled = false
    }
}

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

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
        presenter.cleanUpTests()
    }
    
    func testFetchingFirstPage() {
        // given
        let imagesListService = ImagesListServiceSpy.shared
        let presenter = ImagesListPresenter(imagesListService: imagesListService)
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(imagesListService.nextPageFetched)
        imagesListService.cleanUpTests()
    }
    
    func testFetchingNextPage() {
        // given
        let imagesListService = ImagesListServiceSpy.shared
        let presenter = ImagesListPresenter(imagesListService: imagesListService)
        
        // when
        presenter.fetchNextPageIfAvailable(at: 4)
        
        // then
        XCTAssertTrue(imagesListService.nextPageFetched)
        imagesListService.cleanUpTests()
    }
    
    func testGettingPhotoByIndex() {
        // given
        let imagesListService = ImagesListServiceSpy.shared
        let presenter = ImagesListPresenter(imagesListService: imagesListService)
        let expectedPhoto = photosStub[4]
        
        // when
        let photo = presenter.getPhoto(at: 4)
        
        // then
        XCTAssertEqual(photo.id, expectedPhoto.id)
    }
    
    func testGettingConfigForCellByIndex() {
        // given
        let imagesListService = ImagesListServiceSpy.shared
        let presenter = ImagesListPresenter(imagesListService: imagesListService)
        let expectedConfigURL = photosStub[4].thumbImageURL
        
        // when
        let photo = presenter.getConfigForCell(at: 4)
        
        // then
        XCTAssertEqual(photo?.imageURL, expectedConfigURL)
    }
    
    func testChangingLike() {
        // given
        let imagesListService = ImagesListServiceSpy.shared
        let presenter = ImagesListPresenter(imagesListService: imagesListService)
        
        // when
        presenter.didTapLike(at: 4) { _ in }
        
        // then
        XCTAssertTrue(imagesListService.likeChanged)
        
        imagesListService.cleanUpTests()
    }
}
