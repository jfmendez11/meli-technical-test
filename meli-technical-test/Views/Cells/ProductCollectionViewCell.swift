//
//  ProductCollectionViewCell.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var roundCornersView: UIView! {
        didSet {
            roundCornersView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: Xib functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sketchShadow()
    }
    
    // MARK: UI Setup
    
    func setUpCell(with item: Item) {
        titleLabel.text = item.title
        priceLabel.text = item.price != nil ? "$\(item.price!.currencyFormatter())" : K.ProductView.priceNotAvailable
        if let thumbnail = URL(string: item.thumbnail) {
            thumbnailImageView.load(url: thumbnail)
        } else {
            thumbnailImageView.isSkeletonable = true
            thumbnailImageView.showSkeleton()
        }
    }
}
