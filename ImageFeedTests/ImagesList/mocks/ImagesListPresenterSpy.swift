import Foundation
@testable import ImageFeed

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
