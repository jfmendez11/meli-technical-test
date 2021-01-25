//
//  CategoriesViewController.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit

class CategoriesViewController: UIViewController, Storyboarded {
    // MARK: Outlets
    private lazy var searchBar = UISearchBar()
    @IBOutlet weak var categoriesTableView: UITableView! {
        didSet {
            categoriesTableView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.sketchShadow()
        }
    }
    
    // MARK: Properties
    
    let categoriesWorker = CategoriesWorker()
    
    var categoriesDataSource = [Category]()
    
    let router = Router()
    
    // MARK: Lifecycle fucntions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setNavigationBar()
        categoriesWorker.delegate = self
        categoriesWorker.getCategories()
        router.navigationController = navigationController
    }
    
    // MARK: UI Set up
    
    private func setNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = K.Colors.header
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "suit.heart"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(goToFavorites))
        navigationItem.rightBarButtonItem = favoriteButton
        
        searchBar.placeholder = "Buscar en Mercado Libre"
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        searchBar.sizeToFit()
    }
    
    private func reloadTableViewData() {
        DispatchQueue.main.async {
            self.categoriesTableView.reloadData()
        }
    }
    
    @objc func goToFavorites() {
        router.pushFavoriteViewController()
    }
}
// MARK: -

// MARK: Worker Delegate Extension

extension CategoriesViewController: CategoriesWorkerDelegate {
    func didLoadCategories(categories: [Category]) {
        categoriesDataSource = categories
        reloadTableViewData()
    }
    
    func didFailLoadingCategories(error: Error) {
        log(.error, "\(error)")
    }
}

// MARK: TableView Extensions

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func setUpTableView() {
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let category = categoriesDataSource[indexPath.row].name
        cell.textLabel?.textColor = .blue
        cell.textLabel?.text = category
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoriesDataSource[indexPath.row]
        router.pushSearchViewController(category: category)
    }
}

// MARK: -

extension CategoriesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        router.pushSearchViewController(category: nil)
        return false
    }
}
