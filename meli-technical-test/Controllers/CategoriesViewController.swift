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
            categoriesTableView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.sketchShadow()
        }
    }
    
    @IBOutlet weak var darkModeView: UIView! {
        didSet {
            darkModeView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    // MARK: Properties
    
    let categoriesWorker = CategoriesWorker()
    
    var categoriesDataSource = [Category]()
    
    // MARK: Lifecycle fucntions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkModeSwitch.isOn = UIScreen.main.traitCollection.userInterfaceStyle == .dark
        setUpTableView()
        setUpNavigationBar(title: "Buscar en Mercado Libre", firstResponder: false)
        categoriesWorker.delegate = self
        categoriesWorker.getCategories()
        router.navigationController = navigationController
        
    }
    
    private func reloadTableViewData() {
        DispatchQueue.main.async {
            self.categoriesTableView.reloadData()
        }
    }
    
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
        cell.backgroundColor = UIColor(named: "MyWhite")
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
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor(named: "MyWhite")
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.text = "\tBuscar por categoría"
        return label
    }
}

// MARK: -

extension CategoriesViewController {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        router.pushSearchViewController(category: nil)
        return false
    }
}
