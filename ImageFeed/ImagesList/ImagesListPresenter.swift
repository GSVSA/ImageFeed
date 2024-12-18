import Foundation

struct ImageCellConfig {
    let imageURL: URL
    let isLiked: Bool
    let createdDate: String?
}

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func viewDidLoad()
    func getPhoto(at index: Int) -> Photo
    func getConfigForCell(at index: Int) -> ImageCellConfig?
    func fetchNextPageIfAvailable(at index: Int)
    func didTapLike(at index: Int, completion: @escaping (Result<Bool, Error>) -> Void)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    let imagesListService: ImagesListServiceProtocol
    var imagesListServiceObserver: NSObjectProtocol?
    private(set) var photos: [Photo] = []
    
    init(imagesListService: ImagesListServiceProtocol) {
        self.imagesListService = imagesListService
        self.photos = imagesListService.photos
    }
    
    private let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    func viewDidLoad() {
        
        imagesListService.fetchPhotosNextPage()
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: imagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.didUpdatePhotos()
        }
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
            createdDate: formatDate(imageInfo.createdAt)
        )
    }
    
    func fetchNextPageIfAvailable(at index: Int) {
        let testMode =  ProcessInfo.processInfo.arguments.contains("testMode")
        guard !testMode else { return }
        if index + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func didTapLike(at index: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let photo = getPhoto(at: index)
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                completion(.success(self.getPhoto(at: index).isLiked))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func formatDate(_ date: Date?) -> String? {
        guard let date else { return nil }
        return dateFormatter.string(from: date)
    }
    
    private func didUpdatePhotos() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount == newCount { return }
        view?.updateTable(oldCount: oldCount, newCount: newCount)
    }
}
