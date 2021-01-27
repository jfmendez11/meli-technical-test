//
//  BaseViewController.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 26/01/21.
//

import UIKit

/// Base ViewController. Superclass from which all ViewControllers inherit from.
/// Has all the common properties between the controllers in the project.
class BaseViewController: UIViewController {
    // MARK: UI Components
    
    /// Search bar of the view controller
    lazy var searchBar = UISearchBar()
    
    // MARK: Properties
    
    let router = Router()
    
    // MARK: ViewController lifecycle functions
    
    override func viewDidLoad() {
        router.navigationController = navigationController
    }
    
    func setUpNavigationBar(title: String, firstResponder: Bool) {
        navigationController?.navigationBar.tintColor = K.Colors.barTint
        navigationController?.navigationBar.barTintColor = K.Colors.header
        
        if firstResponder {
            searchBar.becomeFirstResponder()
        }
        
        searchBar.placeholder = title
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.sizeToFit()
    }
}

// MARK: -
/// UISearchBarDelegate conformance
extension BaseViewController: UISearchBarDelegate {}
