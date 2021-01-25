//
//  Endpoint.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

protocol Endpoint {
    var schema: String { get }
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: NetworkTask { get }
}

extension Endpoint {
    var schema: String {
        return "https"
    }
    
    var baseURL: String {
        return "api.mercadolibre.com"
    }
}

enum HTTPMethod: String {
    case get = "GET"
}

enum NetworkTask {
    case request
    case requestParameters(parameters: [URLQueryItem])
}
