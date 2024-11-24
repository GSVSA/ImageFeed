import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let fullImageURL: String
    let isLiked: Bool
}

struct UrlsResult: Codable {
    let thumb: String
    let full: String
}

struct PhotosResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let apiService = APIService()
    
    private init() {}
    
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0) + 1
        print("fetchPhotosNextPage: \(nextPage)")
        apiService.fetch(
            getURLRequest(nextPage),
            nil
        ) { [weak self] (data: [PhotosResult]) in
            guard let self else { return [] }

            let photos = data.map(self.convert)
            self.photos.append(contentsOf: photos)
            NotificationCenter.default.post(
                name: ImagesListService.didChangeNotification,
                object: self,
                userInfo: ["ImagesListServiceDidChange": photos]
            )
            lastLoadedPage = nextPage
            return photos
         }
    }
    
    private func getURLRequest(_ page: Int) -> URLRequest? {
        guard
            let baseURL = Constants.defaultBaseURL,
            var urlComponents = URLComponents(string: baseURL.absoluteString)
        else {
            assertionFailure("Failed to create URL")
            return nil
        }

        urlComponents.path = Constants.images
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
    
    private func convert(_ photo: PhotosResult) -> Photo {
        let dateFormatter = DateFormatter()
        return Photo(
            id: photo.id,
            size: .init(width: photo.width, height: photo.height),
            createdAt: dateFormatter.date(from: photo.createdAt),
            welcomeDescription: photo.description,
            thumbImageURL: photo.urls.thumb,
            fullImageURL: photo.urls.full,
            isLiked: photo.likedByUser
        )
    }
}
