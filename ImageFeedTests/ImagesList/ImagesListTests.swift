import Foundation
@testable import ImageFeed
import XCTest

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
