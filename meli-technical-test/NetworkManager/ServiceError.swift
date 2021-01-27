//
//  NetworkError.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

/// Errors from network requests
enum ServiceError: Error {
    /// The endpoint was not valid
    case invalidURL
    /// The response was not HTTP
    case requestError
    /// The data recieved was nil
    case notDecodedData
    /// Could not decode the data to the specified model
    case dataParsingError
    /// HTTP codes 400...499
    case clientFail
    /// HTTP codes 500...599
    case serverFail
    /// Other failure
    case genericFail(statusCode: Int, data: Data)
}
