//
//  ProductDetailView.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit

class ProductDetailView: UITableViewCell {
    
    // MARK: Outlets
    
    // MARK: Container views
    @IBOutlet weak var saleInformationContainerView: UIView! {
        didSet {
            saleInformationContainerView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var sellerInformationContainerView: UIView! {
        didSet {
            sellerInformationContainerView.layer.cornerRadius = 8
        }
    }
    
    // MARK: Generic info
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: Sale info
    
    @IBOutlet weak var salesInfoStackView: UIStackView! {
        didSet {
            salesInfoStackView.layer.cornerRadius = 16
        }
    }
    @IBOutlet var saleInformationLabels: [UILabel]!
    
    // MARK: Seller info
    
    @IBOutlet weak var sellerSiteLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var soldBySellerLabel: UILabel!
    @IBOutlet weak var cancelledToSellerLabel: UILabel!
    
    @IBOutlet var ratingProgressViews: [UIProgressView]!
    
    // MARK: Other items by seeller
    
    @IBOutlet weak var sellerItemsCollectionView: UICollectionView!
    
    // MARK: Properties
    
    var sellerRelatedItemsDataSource = [Item]()
    private var itemsWorker = ItemsWorker()
    
    // MARK: Closures
    
    // To push another product ViewController if a seller item is selected
    var goToSellerItem: ((Item) -> Void)?
    
    // MARK: Nib functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemsWorker.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: UI Set up
    
    func setUpCell(with item: Item) {
        setUpCollectionView()
        
        titleLabel.text = item.title
        priceLabel.text = item.price != nil ? "$\(item.price!.currencyFormatter())" : "Precio no disponible"
        thumbnailImageView.load(url: item.thumbnail, queue: DispatchQueue.global(), asTemplate: false)
        
        setUpSaleLabels(with: item)
        setUpSellerSiteInformation(with: item.seller, and: item.address)
        setUpTransactionsInfo(with: item.seller.reputation.transactions)
        setUpSellerRating(with: item.seller.reputation.transactions.ratings)
        
        fetchSellerRelatedItems(sellerId: item.seller.id, categoryId: item.category_id)
    }
    
    private func setUpSaleLabels(with item: Item) {
        let labelText = mapped(item: item)
        for label in saleInformationLabels {
            label.text = labelText[label.tag]
        }
        
        setLabelWithHyperLing(label: saleInformationLabels[4], text: "Ver en Mercado Libre", hyperlink: item.permalink)
    }
    
    private func setUpSellerSiteInformation(with seller: Seller, and address: Address) {
        setLabelWithHyperLing(label: sellerSiteLabel, text: "Ver perfil en Mercado Libre", hyperlink: seller.permalink)
        
        locationLabel.text = "\(address.city), \(address.state)"
    }
    
    private func setLabelWithHyperLing(label: UILabel, text: String, hyperlink: URL) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkTapGesture(_:)))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.attachment, value: hyperlink, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSRange(location: 0, length: text.count))
        label.attributedText = attributedString
    }
    
    func setUpTransactionsInfo(with transactions: Transactions) {
        soldBySellerLabel.text = String(transactions.completed) + " ventas"
        cancelledToSellerLabel.text = String(transactions.canceled) + " canceladas"
    }
    
    private func setUpSellerRating(with ratings: Ratings) {
        ratingProgressViews[0].progress = Float(ratings.positive)
        ratingProgressViews[1].progress = Float(ratings.neutral)
        ratingProgressViews[2].progress = Float(ratings.negative)
    }
    
    private func fetchSellerRelatedItems(sellerId: Int, categoryId: String) {
        itemsWorker.getSellerItemsByCategory(sellerId: String(sellerId), categoryId: categoryId)
    }
    
    private func reloadCollectionViewData() {
        DispatchQueue.main.async {
            self.sellerItemsCollectionView.reloadData()
        }
    }
    
    // MARK: Slector methods
    
    @objc private func linkTapGesture(_ sender: UIGestureRecognizer) {
        guard let label = sender.view as? UILabel,
              let url = label.attributedText?.attribute(.attachment, at: 0, effectiveRange: nil) as? URL else {
            log(.error, "No available link")
            return
        }
        UIApplication.shared.open(url)
    }
    
    // MARK: Helper function
    
    private func mapped(item: Item) -> [Int: String] {
        return [
            0: String(item.available_quantity),
            1: String(item.sold_quantity),
            2: item.condition == "new" ? "Nuevo" : "Usado",
            3: item.accepts_mercadopago ? "Sí" : "No"
        ]
    }
}

// MARK: -

// MARK: UICollectionView Delagate and DataSource

extension ProductDetailView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func setUpCollectionView() {
        sellerItemsCollectionView.delegate = self
        sellerItemsCollectionView.dataSource = self
        sellerItemsCollectionView.contentInset.left = 16
        sellerItemsCollectionView.register(
            UINib(nibName: ProductCollectionViewCell.viewID, bundle: .main),
            forCellWithReuseIdentifier: ProductCollectionViewCell.viewID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sellerRelatedItemsDataSource.count > 6 ? 6 : sellerRelatedItemsDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 154, height: 226)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sellerItemsCollectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.viewID, for: indexPath)
        if let cell = cell as? ProductCollectionViewCell {
            let sellerItem = sellerRelatedItemsDataSource[indexPath.row]
            cell.setUpCell(with: sellerItem)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sellerRelatedItemsDataSource[indexPath.item]
        goToSellerItem?(item)
    }
}

// MARK: WorkerDelegate Extension

extension ProductDetailView: ItemsWorkerDelegate {
    func didLoadItems(items: [Item]) {
        sellerRelatedItemsDataSource = items
        reloadCollectionViewData()
    }
    
    func didFailLoadingItems(error: Error) {
        log(.error, "\(error)")
    }
}
