import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case decodeError
    case invalidRequest
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = self.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    logError(source: request.url?.absoluteString, type: "NetworkError", error: "Код ошибка \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                logError(source: request.url?.absoluteString, type: "NetworkError", error: error.localizedDescription)
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                logError(source: request.url?.absoluteString, type: "NetworkError", error: "Неизвестная ошибка")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
    
    func objectTask<DecodableResponse: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<DecodableResponse, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let response = try decoder.decode(DecodableResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    logError(source: request.url?.absoluteString, type: "DecodeError", error: error.localizedDescription, data: data)
                    completion(.failure(NetworkError.decodeError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
