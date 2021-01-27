//
//  ItemWorker.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

/// Delegate to process network responses from the items endpoint
protocol ItemsWorkerDelegate: AnyObject {
    func didLoadItems(items: [Item])
    func didFailLoadingItems(error: Error)
}

/// In charged of communicating with network layer and performing requests to the Items endpoint and passing the result to the delegate.
class ItemsWorker {
    weak var delegate: ItemsWorkerDelegate?
    var itemsClient: APIClient<Products>
    
    init(itemsClient: APIClient<Products> = APIClient<Products>()) {
        self.itemsClient = itemsClient
    }
    
    /// Searches items based on the query and the category
    /// - Parameter criteria: The item the user is searching for
    /// - Parameter categoryId: The id of the category if the user is filtering by category. Nil otherwise
    func searchItems(criteria: String, categoryId: String?) {
        itemsClient.request(endpoint: SearchAPI.getItemsBySearch(criteria: criteria, ctaegoryId: categoryId)) { [weak self] response in
            switch response {
            case .success(let products):
                self?.delegate?.didLoadItems(items: products.items)
            case .failure(let error):
                self?.delegate?.didFailLoadingItems(error: error)
            }
        }
    }
    
    /// Searches items by category
    /// - Parameter categoryId: The id of the category from which the user wants the item
    func getItemsByCategory(categoryId: String) {
        itemsClient.request(endpoint: SearchAPI.getItemsByCategory(categoryId: categoryId)) { [weak self] response in
            switch response {
            case .success(let products):
                self?.delegate?.didLoadItems(items: products.items)
            case .failure(let error):
                self?.delegate?.didFailLoadingItems(error: error)
            }
        }
    }
    
    /// Searches related items by the seller (items from a specific seller which belong to the same category)
    /// - Parameter sellerId: The id of the seller to search items from
    /// - Parameter categoryId: The id of the category if the user is filtering by category
    func getSellerItemsByCategory(sellerId: String, categoryId: String) {
        itemsClient.request(endpoint: SearchAPI.getItemsBySellerAndCategory(sellerId: sellerId, categoryId: categoryId)) { [weak self] response in
            switch response {
            case .success(let products):
                self?.delegate?.didLoadItems(items: products.items)
            case .failure(let error):
                self?.delegate?.didFailLoadingItems(error: error)
            }
        }
    }
}
