//
//  SearchViewController.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit
import SkeletonView

class SearchViewController: BaseViewController, Storyboarded {
    
    @IBOutlet weak var itemsTableView: UITableView!
    
    lazy var emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var searchTask: DispatchWorkItem?
    
    let itemsWorker = ItemsWorker()
    
    var itemsDataSource = [Item]()
    
    var category: Category?
    
    private var shouldAnimate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar(title: category != nil ? "Buscar en \(category!.name)" : "Buscar en Mercado Libre", firstResponder: category == nil)
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
    
    private func updateEmptyState(emoji: String, message: String) {
        emptyStateView.emojiLabel.text = emoji
        emptyStateView.messageLabel.text = message
        emptyStateView.isHidden = false
        itemsTableView.isHidden = true
    }
    
    private func dismissEmptyState() {
        self.emptyStateView.isHidden = true
        self.itemsTableView.isHidden = false
    }
    
    private func sendSearchRequest(criteria: String) {
        if !criteria.isEmpty || category != nil {
            shouldAnimate = true
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

extension SearchViewController: ItemsWorkerDelegate {
    func didLoadItems(items: [Item]) {
        if items.isEmpty {
            DispatchQueue.main.async {
                self.updateEmptyState(emoji: "🧐", message: "¡No encontramos el artículo que estás buscando!\nRevisa que esté bien escrito e intena de nuevo.")
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
            self.updateEmptyState(emoji: "😰", message: "¡Ocurrió un errror!\nPorfavor, intenta de nuevo.")
        }
    }
}

extension SearchViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    private func setUpTableView() {
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        itemsTableView.rowHeight = UITableView.automaticDimension
        itemsTableView.estimatedRowHeight = 100
        itemsTableView.register(UINib(nibName: ProductTableViewCell.viewID, bundle: .main), forCellReuseIdentifier: ProductTableViewCell.viewID)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ProductTableViewCell.viewID
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldAnimate {
            return 10
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

extension SearchViewController {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if category == nil,
           let text = searchBar.text,
           text.isEmpty {
            updateEmptyState(emoji: "🔎", message: "¡Escribe el nombre del\nartículo que deseas buscar!")
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        
        if category == nil && searchText.isEmpty {
            updateEmptyState(emoji: "🔎", message: "¡Escribe el artículo que deseas buscar!")
        } else if !searchText.isEmpty {
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
