//
//  APIClient.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

/// Client to perform network requests.
/// T is the model from which the request decodes the response data into.
class APIClient<T> where T: Codable {
    
    /// Performs a URL session task to the specified Endpoint
    /// - Parameter endpoint: Endpoint of the request.
    /// - Parameter completion: Closure to execute after the back-end responds
    func request(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = buildRequest(from: endpoint) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        let urlSession = URLSession(configuration: .default)
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        do {
                            let decoder = JSONDecoder()
                            let decodedData = try decoder.decode(T.self, from: data)
                            completion(.success(decodedData))
                        } catch {
                            log(.error, "\(error)")
                            completion(.failure(ServiceError.dataParsingError))
                        }
                    case 400...499:
                        completion(.failure(ServiceError.clientFail))
                    case 500...599:
                        completion(.failure(ServiceError.serverFail))
                    default:
                        completion(.failure(ServiceError.genericFail(statusCode: response.statusCode, data: data)))
                    }
                    #if DEBUG
                    self.networkDebugger(request: request, data: data, error: error)
                    #endif
                } else {
                    completion(.failure(ServiceError.requestError))
                }
            } else {
                completion(.failure(ServiceError.notDecodedData))
            }
        }
        
        task.resume()
    }
    
    /// The function was developed thinking on building GET requests, given the nature of the challenge.
    /// Builds an URL request with the endpoint's info
    /// - Parameter endpoint: Endpoint where the request is built upon.
    private func buildRequest(from endpoint: Endpoint) -> URLRequest? {
        var components = URLComponents()
        components.scheme = endpoint.schema
        components.host = endpoint.baseURL
        components.path = endpoint.path
        
        switch endpoint.task {
        case .requestParameters(let parameters):
            components.queryItems = parameters
        default:
            break
        }
        
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        return request
    }
    
    /// Debugs the network request and response.
    /// - Parameter request: Request executed
    /// - Parameter data: Data fetched if the service responded successfully or nil in the other case
    /// - Parameter error: Error of the request or nil if the service responden successfully
    private func networkDebugger(request: URLRequest, data: Data?, error: Error?) {
        if let data = data {
            let message =
            """
            HTTP
            Request: --------------------------------
            Url:         \(request.url?.absoluteString ?? "URL IS NIL")
            Method:      \(request.httpMethod ?? "GET")
            Response: -------------------------------
            Data:        \(String(data: data, encoding: .utf8) ?? "COULD NOT DECODE DATA")
            """
            log(.info, message)
        }
        if let error = error {
            var message =
            """
            HTTP
            👽 - CLEAN
            Request: --------------------------------
            Url:         \(request.url?.absoluteString ?? "URL IS NIL")
            Method:      \(request.httpMethod ?? "GET")
            Error: -------------------------------
            """
            message += "\nDescription: \(error.localizedDescription)"
            log(.error, message)
        }
    }
}
