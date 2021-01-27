//
//  SearchAPI.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

/// Endpoints to perform Searches
enum SearchAPI {
    case getItemsByCategory(categoryId: String)
    case getItemsBySearch(criteria: String, ctaegoryId: String?)
    case getItemsBySellerAndCategory(sellerId: String, categoryId: String)
}

extension SearchAPI: Endpoint {
    var path: String {
        let subPath = "/sites/MLA/search"
        switch self {
        case .getItemsByCategory, .getItemsBySearch, .getItemsBySellerAndCategory:
            return subPath
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getItemsByCategory, .getItemsBySearch, .getItemsBySellerAndCategory:
            return .get
        }
    }
    
    var task: NetworkTask {
        switch self {
        case .getItemsByCategory(let categoryId):
            let categoryParam = URLQueryItem(name: "category", value: categoryId)
            return .requestParameters(parameters: [categoryParam])
        case .getItemsBySearch(let critearia, let categoryId):
            let searchCriteria = URLQueryItem(name: "q", value: critearia)
            let categoryParam = URLQueryItem(name: "category", value: categoryId)
            return .requestParameters(parameters: [searchCriteria, categoryParam])
        case .getItemsBySellerAndCategory(let sellerId, let categoryId):
            let sellerParam = URLQueryItem(name: "seller_id", value: sellerId)
            let categoryParam = URLQueryItem(name: "category", value: categoryId)
            return .requestParameters(parameters: [sellerParam, categoryParam])
        }
    }
}
