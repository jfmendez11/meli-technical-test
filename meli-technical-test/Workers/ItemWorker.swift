//
//  ItemWorker.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

protocol ItemsWorkerDelegate: AnyObject {
    func didLoadItems(items: [Item])
    func didFailLoadingItems(error: Error)
}

class ItemsWorker {
    weak var delegate: ItemsWorkerDelegate?
    var itemsClient: APIClient<Products>
    
    init(itemsClient: APIClient<Products> = APIClient<Products>()) {
        self.itemsClient = itemsClient
    }
    
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
