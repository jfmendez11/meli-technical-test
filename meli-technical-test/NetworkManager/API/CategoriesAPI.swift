//
//  SitesAPI.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

/// Endpoints to retrieve categories.
enum CategoriesAPI {
    case getSiteCategories
}

extension CategoriesAPI: Endpoint {
    var path: String {
        let subPath = "/sites/MLA/categories"
        switch self {
        case .getSiteCategories:
            return subPath
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getSiteCategories:
            return .get
        }
    }
    
    var task: NetworkTask {
        switch self {
        case .getSiteCategories:
            return .request
        }
    }
}
