//
//  ProductTableViewCell.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit
import SkeletonView

class ProductTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    // MARK: Xib functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: UI Setup
    
    func setUpCell(with item: Item) {
        titleLabel.text = item.title
        priceLabel.text = item.price != nil ? "$\(item.price!.currencyFormatter())" : "Precio no disponible"
        conditionLabel.text = item.condition == "new" ? "Nuevo" : "Usado"
        shippingLabel.isHidden = item.shipping.isFreeShipping
        if let thumbnail = URL(string: item.thumbnail) {
            thumbnailImageView.load(url: thumbnail)
        } else {
            thumbnailImageView.isSkeletonable = true
            thumbnailImageView.showSkeleton()
        }
    }
}
