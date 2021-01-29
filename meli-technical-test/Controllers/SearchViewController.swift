//
//  SearchViewController.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit
import SkeletonView

class SearchViewController: BaseViewController, Storyboarded {
    
    // MARK: Outlets
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    // MARK: Other UI Components
    
    /// Empty state for different scenarios
    lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Properties
    
    /// Task to perform a search query every 0.75s
    var searchTask: DispatchWorkItem?
    
    let itemsWorker = ItemsWorker()
    
    var itemsDataSource = [Item]()
    
    /// Category selected by the user or nil if the user is not filtering by categories
    var category: Category?
    
    /// Determines weather or not to show the skeleton view
    private var shouldAnimate = true
    
    // MARK: ViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar(title: category != nil ? K.SearchView.categoryPlaceholder + category!.name : K.SearchView.placeholder,
                           firstResponder: category == nil)
        setUpTableView()
        setUpEmptyStateView()
        itemsWorker.delegate = self
        if category != nil {
            emptyStateView.isHidden = true
            sendSearchRequest(criteria: "")
        }
    }
    
    // MARK: UI Set up
    
    override func setUpNavigationBar(title: String, firstResponder: Bool) {
        super.setUpNavigationBar(title: title, firstResponder: firstResponder)
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .cancel, target: self, action: #selector(popViewController))
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setUpEmptyStateView() {
        view.addSubview(emptyStateView)
        emptyStateView.centerXAnchor.constraint(equalTo: itemsTableView.centerXAnchor).isActive = true
        emptyStateView.bottomAnchor.constraint(equalTo: itemsTableView.centerYAnchor).isActive = true
        emptyStateView.leadingAnchor.constraint(equalTo: itemsTableView.leadingAnchor).isActive = true
        emptyStateView.trailingAnchor.constraint(equalTo: itemsTableView.trailingAnchor).isActive = true
    }
    
    private func updateEmptyState(state: EmptyState) {
        emptyStateView.emptyState = state
        emptyStateView.isHidden = false
        itemsTableView.isHidden = true
    }
    
    private func dismissEmptyState() {
        emptyStateView.isHidden = true
        itemsTableView.isHidden = false
    }
    
    private func sendSearchRequest(criteria: String) {
        if !criteria.isEmpty || category != nil {
            itemsWorker.searchItems(criteria: criteria, categoryId: category?.id)
        }
    }
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func reloadTableViewData() {
        DispatchQueue.main.async {
            self.itemsTableView.reloadData()
        }
    }
}

// MARK: -

/// ItemsWorkerDelegate conformance
extension SearchViewController: ItemsWorkerDelegate {
    func didLoadItems(items: [Item]) {
        if items.isEmpty {
            DispatchQueue.main.async {
                self.updateEmptyState(state: .itemNotFound)
            }
        } else {
            itemsDataSource = items
            shouldAnimate = false
            reloadTableViewData()
        }
    }
    
    func didFailLoadingItems(error: Error) {
        log(.error, "\(error)")
        shouldAnimate = false
        DispatchQueue.main.async {
            self.updateEmptyState(state: .error)
        }
    }
}

/// UITableViewDelegate, SkeletonTableViewDataSource conformance
/// SkeletonTableViewDataSource inherits from UITableViewDataSource
/// SkeletonTableViewDataSource is used for the animations when loading
extension SearchViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    private func setUpTableView() {
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        itemsTableView.rowHeight = UITableView.automaticDimension
        itemsTableView.estimatedRowHeight = K.SearchView.estimatedRowHeight
        itemsTableView.register(UINib(nibName: ProductTableViewCell.viewID, bundle: .main), forCellReuseIdentifier: ProductTableViewCell.viewID)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ProductTableViewCell.viewID
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldAnimate {
            return K.SearchView.numberOfLoadingCells
        }
        return itemsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemsTableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.viewID, for: indexPath)
        if let cell = cell as? ProductTableViewCell,
           !shouldAnimate {
            let item = itemsDataSource[indexPath.row]
            cell.setUpCell(with: item)
        }
        if shouldAnimate {
            cell.showAnimatedSkeleton()
        } else {
            cell.hideSkeleton()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemsDataSource[indexPath.row]
        itemsTableView.deselectRow(at: indexPath, animated: true)
        router.pushProductViewController(item: item)
    }
}

/// SearchBarDelegate conformance
extension SearchViewController {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if category == nil,
           let text = searchBar.text,
           text.isEmpty {
            updateEmptyState(state: .search)
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        
        if !shouldAnimate {
            shouldAnimate = true
            itemsTableView.reloadData()
        }
        
        if category == nil && searchText.isEmpty {
            updateEmptyState(state: .search)
        } else {
            dismissEmptyState()
        }
        
        let task = DispatchWorkItem { [weak self] in
            self?.sendSearchRequest(criteria: searchText)
        }
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
