//
//  NetworkError.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

enum ServiceError: Error {
    case invalidURL
    case requestError
    case notDecodedData
    case dataParsingError
    case clientFail
    case serverFail
    case genericFail(statusCode: Int, data: Data)
}
