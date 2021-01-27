//
//  Endpoint.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

/// Endpoint parameters used in network requests
protocol Endpoint {
    /// The schema of the endpoint
    var schema: String { get }
    /// Base URL of the endpoint (host)
    var baseURL: String { get }
    /// Path of the endpoint
    var path: String { get }
    /// HTTP Method to perform
    var httpMethod: HTTPMethod { get }
    /// HTTP task to execute
    var task: NetworkTask { get }
}

/// Defualt implementation of the endpoint schema and base URL
extension Endpoint {
    var schema: String {
        return "https"
    }
    
    var baseURL: String {
        return "api.mercadolibre.com"
    }
}

/// Enum containing HTTP Methods. For the project, only GET requests where performed
enum HTTPMethod: String {
    case get = "GET"
}

/// Possible network tasks to execute. Given that the project only performs GET requests, the possible tasks are a GET with or without query items.
enum NetworkTask {
    case request
    case requestParameters(parameters: [URLQueryItem])
}
