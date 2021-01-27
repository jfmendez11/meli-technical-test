//
//  ProductViewController.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit
import WebKit

/// The Product Detail view is embedded in a TableView to take advantage of the automatic sizing without the need to implement a scroll view.
class ProductViewController: BaseViewController, Storyboarded {
    
    // MARK: Outlets
    
    @IBOutlet weak var productDetailView: UITableView!
    
    // MARK: Properties
    
    /// Selected item by the user
    var item: Item?
    
    // MARK: ViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router.navigationController = navigationController
        productDetailView.delegate = self
        productDetailView.dataSource = self
        productDetailView.separatorStyle = .none
        productDetailView.register(UINib(nibName: ProductDetailView.viewID, bundle: .main), forCellReuseIdentifier: ProductDetailView.viewID)
        productDetailView.estimatedRowHeight = K.ProductView.estimatedRowHeight
    }
}

// MARK: -

/// UITableViewDelegate, UITableViewDataSource conformance
extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return K.ProductView.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productDetailView.dequeueReusableCell(withIdentifier: ProductDetailView.viewID, for: indexPath)
        if let cell = cell as? ProductDetailView,
           let item = item {
            cell.setUpCell(with: item)
            cell.goToSellerItem = { [weak self] item in
                self?.router.pushProductViewController(item: item)
            }
        }
        return cell
    }
}
