//
//  CategoryWorker.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

/// Delegate to process network responses from the categories endpoint
protocol CategoriesWorkerDelegate: AnyObject {
    func didLoadCategories(categories: [Category])
    func didFailLoadingCategories(error: Error)
}

/// In charged of communicating with network layer and performing requests to the categories endpoint and passing the result to the delegate.
class CategoriesWorker {
    weak var delegate: CategoriesWorkerDelegate?
    var categoriesClient: APIClient<[Category]>
    
    init(categoriesClient: APIClient<[Category]> = APIClient<[Category]>()) {
        self.categoriesClient = categoriesClient
    }
    
    /// Fetches the categories
    func getCategories() {
        categoriesClient.request(endpoint: CategoriesAPI.getSiteCategories) { [weak self] response in
            switch response {
            case .success(let categories):
                self?.delegate?.didLoadCategories(categories: categories)
            case .failure(let error):
                self?.delegate?.didFailLoadingCategories(error: error)
            }
        }
    }
}
