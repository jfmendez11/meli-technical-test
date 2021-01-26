//
//  BaseViewController.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 26/01/21.
//

import UIKit

class BaseViewController: UIViewController {
    lazy var searchBar = UISearchBar()
    
    let router = Router()
    
    var osTheme: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
    
    override func viewDidLoad() {
        router.navigationController = navigationController
    }
    
    func setUpNavigationBar(title: String, firstResponder: Bool) {
        navigationController?.navigationBar.tintColor = UIColor(named: "BarTint")
        navigationController?.navigationBar.barTintColor = K.Colors.header
        
        searchBar.placeholder = title
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.sizeToFit()
    }
}

extension BaseViewController: UISearchBarDelegate {}
