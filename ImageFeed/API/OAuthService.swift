import Foundation

private enum AuthError: Error {
    case decodeError
}

final class OAuthService {
    static let shared = OAuthService()
    private let oAuthStorage = OAuthTokenStorage()
    
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = getRequestURL(code: code) else {
            print("ERROR: Request is not exist")
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    let accessToken = response.accessToken
                    self?.oAuthStorage.token = accessToken
                    completion(.success(accessToken))
                } catch {
                    completion(.failure(AuthError.decodeError))
                    print("ERROR: Fail to decode -> \(error)")
                }
            case .failure(let error):
                completion(.failure(error))
                print("ERROR: Request was failed")
            }
        }
        
        task.resume()
    }
    
    private func getRequestURL(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com") else {
            print("ERROR: URLComponents")
            return nil
        }

        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]

        guard let url = urlComponents.url else {
            print("ERROR: URL is not exist")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
