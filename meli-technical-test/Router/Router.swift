//
//  Router.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit

/// Manages the navgation across the project within a navigation controller
class Router {
    
    var navigationController: UINavigationController?
    
    /// Pushes the SearchViewController. Sets the category in the SearchViewController if the user selects one.
    /// - Parameter category: Category selected by the user. nil otherwise
    func pushSearchViewController(category: Category?) {
        let searchVC = SearchViewController.instantiate(from: .Search)
        searchVC.category = category
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    /// Pushes the ProductViewController. Sets the item in the ProductViewController in order to display the relevant information.
    /// - Parameter item: Selected item by the user.
    func pushProductViewController(item: Item) {
        let productVC = ProductViewController.instantiate(from: .Product)
        productVC.item = item
        navigationController?.pushViewController(productVC, animated: true)
    }
}
