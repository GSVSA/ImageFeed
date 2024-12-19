import Foundation

protocol ImagesListServiceProtocol {
    var didChangeNotification: Notification.Name { get }
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    func reset()
}

final class ImagesListService: ImagesListServiceProtocol {
    static let shared = ImagesListService()
    let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let apiService = APIService()
    private let dateFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        return dateFormatter
    }()
    
    private init() {}
    
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0) + 1
        apiService.fetch(
            getURLRequest(nextPage),
            nil
        ) { [weak self] (data: [PhotoResponse]) in
            guard let self else { return [] }

            let photos = data.map(self.convert)
            self.photos.append(contentsOf: photos)
            NotificationCenter.default.post(
                name: self.didChangeNotification,
                object: self,
                userInfo: ["ImagesListServiceDidChange": photos]
            )
            lastLoadedPage = nextPage
            return photos
         }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        apiService.fetch(
            getURLRequest(photoId: photoId, isLike: isLike),
            completion
        ) { [weak self] (data: LikeResponse) in
            guard let self else { return }
            
            if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                let photo = self.convert(data.photo)
                self.photos[index] = photo
            }
         }
    }
    
    func reset() {
        photos.removeAll()
        lastLoadedPage = nil
    }
    
    private func getURLRequest(photoId: String, isLike: Bool) -> URLRequest? {
        guard
            let baseURL = URLPaths.defaultBaseURL,
            var urlComponents = URLComponents(string: baseURL.absoluteString)
        else {
            assertionFailure("Failed to create URL")
            return nil
        }

        urlComponents.path = URLPaths.likePath(for: photoId)

        guard let url = urlComponents.url else {
            assertionFailure("URL is not exist")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        return request
    }
    
    private func getURLRequest(_ page: Int) -> URLRequest? {
        guard
            let baseURL = URLPaths.defaultBaseURL,
            var urlComponents = URLComponents(string: baseURL.absoluteString)
        else {
            assertionFailure("Failed to create URL")
            return nil
        }

        urlComponents.path = URLPaths.photosPath
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
        ]

        guard let url = urlComponents.url else {
            assertionFailure("URL is not exist")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    private func convert(_ photo: PhotoResponse) -> Photo {
        return Photo(
            id: photo.id,
            size: .init(width: photo.width, height: photo.height),
            createdAt: dateFormatter.date(from: photo.createdAt ?? ""),
            thumbImageURL: URL(string: photo.urls.thumb),
            fullImageURL: URL(string: photo.urls.full),
            isLiked: photo.likedByUser
        )
    }
}
