import Foundation

final class APIService {
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let tokenStorage = OAuthTokenStorage()
    
    func fetch<DecodableResponse: Decodable, R>(
        _ urlRequest: URLRequest?,
        _ completion: ((Result<R, Error>) -> Void)?,
        selector: @escaping (DecodableResponse) -> R
    ) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard
            let token = tokenStorage.token,
            var request = urlRequest
        else {
            assertionFailure("Request is not exist")
            completion?(.failure(NetworkError.invalidRequest))
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<DecodableResponse, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                let selectedData = selector(data)
                completion?(.success(selectedData))
            case .failure(let error):
                completion?(.failure(error))
            }
            self.task = nil
        }

        task.resume()
    }
}
