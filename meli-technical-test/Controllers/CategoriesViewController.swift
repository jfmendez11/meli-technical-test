//
//  CategoriesViewController.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit

class CategoriesViewController: BaseViewController, Storyboarded {
    
    // MARK: Outlets
    
    @IBOutlet weak var categoriesTableView: UITableView! {
        didSet {
            categoriesTableView.layer.cornerRadius = K.Layer.defaultHeaderCornerRadius
        }
    }
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.sketchShadow()
        }
    }
    
    @IBOutlet weak var darkModeView: UIView! {
        didSet {
            darkModeView.layer.cornerRadius = K.Layer.defaultHeaderCornerRadius
        }
    }
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    // MARK: Properties
    
    let categoriesWorker = CategoriesWorker()
    
    var categoriesDataSource = [Category]()
    
    // MARK: ViewContoller Lifecycle fucntions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeSwitch.isOn = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        setUpTableView()
        setUpNavigationBar(title: K.SearchView.placeholder, firstResponder: false)
        categoriesWorker.delegate = self
        categoriesWorker.getCategories()
        router.navigationController = navigationController
        
    }
    
    /// Reloads the table view in the main thread
    private func reloadTableViewData() {
        DispatchQueue.main.async {
            self.categoriesTableView.reloadData()
        }
    }
    
    // MARK: Actions
    
    @IBAction func darkModeSwitchChanged(_ sender: UISwitch) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
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
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.backgroundColor = K.Colors.myWhite
        cell.textLabel?.textColor = .systemBlue
        cell.textLabel?.text = category
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoriesDataSource[indexPath.row]
        categoriesTableView.deselectRow(at: indexPath, animated: true)
        router.pushSearchViewController(category: category)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return K.CategoriesView.estimatedHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return K.CategoriesView.headerText
    }
}

// MARK: -

extension CategoriesViewController {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        router.pushSearchViewController(category: nil)
        return false
    }
}
