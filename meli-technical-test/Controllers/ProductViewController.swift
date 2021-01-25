//
//  ProductViewController.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit
import WebKit

class ProductViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var productDetailView: UITableView!
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productDetailView.delegate = self
        productDetailView.dataSource = self
        productDetailView.register(UINib(nibName: ProductDetailView.viewID, bundle: .main), forCellReuseIdentifier: ProductDetailView.viewID)
        productDetailView.estimatedRowHeight = 200
    }
}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productDetailView.dequeueReusableCell(withIdentifier: ProductDetailView.viewID, for: indexPath)
        if let cell = cell as? ProductDetailView,
           let item = item {
            cell.setUpCell(with: item)
            cell.showWebView = { url in
                UIApplication.shared.open(url)
            }
        }
        return cell
    }
}
