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
    
    @IBOutlet weak var freeShippingLabel: UILabel!
    @IBOutlet var saleInformationLabels: [UILabel]!
    
    // MARK: Seller info
    
    @IBOutlet weak var sellerSiteLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var soldBySellerLabel: UILabel!
    @IBOutlet weak var cancelledToSellerLabel: UILabel!
    
    @IBOutlet weak var possitiveRatingProgressView: UIProgressView!
    @IBOutlet weak var neutralRatingProgressView: UIProgressView!
    @IBOutlet weak var negativeRatingProgressView: UIProgressView!
    
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
    
    // MARK: UI Set up
    
    func setUpCell(with item: Item) {
        setUpCollectionView()
        
        titleLabel.text = item.title
        priceLabel.text = item.price != nil ? "$\(item.price!.currencyFormatter())" : K.ProductView.priceNotAvailable
        if let thumbnail = URL(string: item.thumbnail) {
            thumbnailImageView.load(url: thumbnail)
        } else {
            thumbnailImageView.isSkeletonable = true
            thumbnailImageView.showSkeleton()
        }
        freeShippingLabel.isHidden = item.shipping.isFreeShipping
        
        setUpSaleLabels(with: item)
        setUpSellerSiteInformation(with: item.seller, and: item.address)
        setUpTransactionsInfo(with: item.seller.reputation?.transactions)
        setUpSellerRating(with: item.seller.reputation?.transactions.ratings)
        
        fetchSellerRelatedItems(sellerId: item.seller.id, categoryId: item.categoryId)
    }
    
    private func setUpSaleLabels(with item: Item) {
        let labelText = K.ProductView.mapped(item: item)
        for label in saleInformationLabels {
            label.text = labelText[label.tag]
        }
        if let permalink = URL(string: item.permalink) {
            setLabelWithHyperLink(label: saleInformationLabels[4], text: K.ProductView.linkDescription, hyperlink: permalink)
        }
    }
    
    private func setUpSellerSiteInformation(with seller: Seller, and address: Address) {
        if let permalink = URL(string: seller.permalink) {
            setLabelWithHyperLink(label: sellerSiteLabel, text: K.ProductView.linkDescriptionSeller, hyperlink: permalink)
        }
        
        locationLabel.text = "\(address.city), \(address.state)"
    }
    
    private func setLabelWithHyperLink(label: UILabel, text: String, hyperlink: URL) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkTapGesture(_:)))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.attachment, value: hyperlink, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSRange(location: 0, length: text.count))
        label.attributedText = attributedString
    }
    
    func setUpTransactionsInfo(with transactions: Transactions?) {
        soldBySellerLabel.text = String(transactions?.completed ?? 0) + " ventas"
        cancelledToSellerLabel.text = String(transactions?.canceled ?? 0) + " canceladas"
    }
    
    private func setUpSellerRating(with ratings: Ratings?) {
        possitiveRatingProgressView.progress = Float(ratings?.positive ?? 0)
        neutralRatingProgressView.progress = Float(ratings?.neutral ?? 0)
        negativeRatingProgressView.progress = Float(ratings?.negative ?? 0)
    }
    
    private func reloadCollectionViewData() {
        DispatchQueue.main.async {
            self.sellerItemsCollectionView.reloadData()
        }
    }
    
    // MARK: Network requests
    
    private func fetchSellerRelatedItems(sellerId: Int, categoryId: String) {
        itemsWorker.getSellerItemsByCategory(sellerId: String(sellerId), categoryId: categoryId)
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
}

// MARK: -

// UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout conformance
extension ProductDetailView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func setUpCollectionView() {
        sellerItemsCollectionView.delegate = self
        sellerItemsCollectionView.dataSource = self
        sellerItemsCollectionView.contentInset.left = K.ProductView.insetLeft
        sellerItemsCollectionView.register(
            UINib(nibName: ProductCollectionViewCell.viewID, bundle: .main),
            forCellWithReuseIdentifier: ProductCollectionViewCell.viewID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sellerRelatedItemsDataSource.count > K.ProductView.numberOfRelatedItems ?
            K.ProductView.numberOfRelatedItems : sellerRelatedItemsDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return K.ProductView.relatedItemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return K.ProductView.minimumLineSpacingForSectionAt
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

/// ItemsWorkerDelegate conformance
extension ProductDetailView: ItemsWorkerDelegate {
    func didLoadItems(items: [Item]) {
        sellerRelatedItemsDataSource = items
        reloadCollectionViewData()
    }
    
    func didFailLoadingItems(error: Error) {
        log(.error, "\(error)")
    }
}
