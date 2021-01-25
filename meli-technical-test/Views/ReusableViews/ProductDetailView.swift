//
//  ProductDetailView.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit

class ProductDetailView: UITableViewCell {
    
    // MARK: Outlets
    
    // MARK: Generic info
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: Sale info
    
    @IBOutlet var saleInformationLabels: [UILabel]!
    
    // MARK: Attributes info
    
    @IBOutlet weak var attributesStackView: UIStackView!
    
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
    
    var showWebView: ((URL) -> Void)?
    
    // MARK: Nib functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemsWorker.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpCell(with item: Item) {
        setUpCollectionView()
        
        titleLabel.text = item.title
        priceLabel.text = item.price != nil ? "$\(item.price!.currencyFormatter())" : "Precio no disponible"
        thumbnailImageView.load(url: item.thumbnail, queue: DispatchQueue.global(), asTemplate: false)
        
        setUpSaleLabels(with: item)
        setUpItemAttributes(with: item.attributes)
        setUpSellerSiteInformation(with: item.seller, and: item.address)
        setUpTransactionsInfo(with: item.seller.reputation.transactions)
        setUpSellerRating(with: item.seller.reputation.transactions.ratings)
        
        fetchSellerRelatedItems(sellerId: item.seller.id, categoryId: item.category_id)
    }
    
    private func setUpSaleLabels(with item: Item) {
        saleInformationLabels[0].text = String(item.available_quantity)
        saleInformationLabels[1].text = String(item.sold_quantity)
        saleInformationLabels[2].text = item.condition == "new" ? "Nuevo" : "Usado"
        saleInformationLabels[3].text = item.accepts_mercadopago ? "Sí" : "No"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkTapGesture))
        saleInformationLabels[4].isUserInteractionEnabled = true
        saleInformationLabels[4].addGestureRecognizer(tap)
        let seeInML = "Ver en Mercado Libre"
        let attributedString = NSMutableAttributedString(string: seeInML)
        attributedString.addAttribute(.link, value: item.permalink, range: NSRange(location: 0, length: seeInML.count))
        saleInformationLabels[4].attributedText = attributedString
    }
    
    private func setUpItemAttributes(with attributes: [ItemAttribute]) {
        for attribute in attributes {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            
            let nameLabel = UILabel()
            nameLabel.text = attribute.name
            
            let valueLabel = UILabel()
            valueLabel.text = attribute.value ?? "No disponible"
            
            stackView.addSubview(nameLabel)
            stackView.addSubview(valueLabel)
            
            attributesStackView.addSubview(stackView)
        }
        
        if attributes.isEmpty {
            let label = UILabel()
            label.text = "Información no suministrada por el vendedor"
            attributesStackView.addSubview(label)
        }
        
    }
    
    private func setUpSellerSiteInformation(with seller: Seller, and address: Address) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkTapGesture))
        let seeInML = "Ver perfil en Mercado Libre"
        let attributedString = NSMutableAttributedString(string: seeInML)
        attributedString.addAttribute(.link, value: seller.permalink, range: NSRange(location: 0, length: seeInML.count))
        sellerSiteLabel.isUserInteractionEnabled = true
        sellerSiteLabel.addGestureRecognizer(tap)
        sellerSiteLabel.attributedText = attributedString
        
        locationLabel.text = "\(address.city), \(address.state)"
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
    
    @objc private func linkTapGesture() {
        if let url = saleInformationLabels[4].attributedText?.attribute(.link, at: 0, effectiveRange: nil) as? URL {
            showWebView?(url)
        }
    }
    
}

extension ProductDetailView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private func setUpCollectionView() {
        sellerItemsCollectionView.delegate = self
        sellerItemsCollectionView.dataSource = self
        sellerItemsCollectionView.register(UINib(nibName: ProductCollectionViewCell.viewID, bundle: .main), forCellWithReuseIdentifier: ProductCollectionViewCell.viewID)
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
}

extension ProductDetailView: ItemsWorkerDelegate {
    func didLoadItems(items: [Item]) {
        sellerRelatedItemsDataSource = items
        reloadCollectionViewData()
    }
    
    func didFailLoadingItems(error: Error) {
        log(.error, "\(error)")
    }
}
