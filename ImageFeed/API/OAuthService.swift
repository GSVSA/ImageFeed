import Foundation

private struct OAuthTokenResponseBody: Codable {
    let accessToken: String
}

final class OAuthService {
    static let shared = OAuthService()
    private let oAuthStorage = OAuthTokenStorage()
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        task?.cancel()
        lastCode = code
        
        guard let request = getRequestURL(code: code) else {
            assertionFailure("Request is not exist")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let data):
                let accessToken = data.accessToken
                self?.oAuthStorage.token = accessToken
                completion(.success(accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
            
            self?.task = nil
            self?.lastCode = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func getRequestURL(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.authBaseURL) else {
            assertionFailure("Failed to create URL")
            return nil
        }

        urlComponents.path = Constants.tokenPath
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]

        guard let url = urlComponents.url else {
            assertionFailure("URL is not exist")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
