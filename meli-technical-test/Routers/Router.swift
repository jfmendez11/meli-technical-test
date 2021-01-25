//
//  Router.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit

class Router {
    
    var navigationController: UINavigationController?
    
    func pushFavoriteViewController() {
        let favoriteVC = FavoritesViewController.instantiate(from: .Favorites)
        navigationController?.pushViewController(favoriteVC, animated: true)
    }
    
    func pushSearchViewController(category: Category?) {
        let searchVC = SearchViewController.instantiate(from: .Search)
        searchVC.category = category
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func pushProductViewController(item: Item) {
        let productVC = ProductViewController.instantiate(from: .Product)
        productVC.item = item
        navigationController?.pushViewController(productVC, animated: true)
    }
}
