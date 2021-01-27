//
//  ProductCollectionViewCell.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var roundCornersView: UIView! {
        didSet {
            roundCornersView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sketchShadow()
    }
    
    func setUpCell(with item: Item) {
        titleLabel.text = item.title
        priceLabel.text = item.price != nil ? "$\(item.price!.currencyFormatter())" : "Precio no disponible"
        if let thumbnail = URL(string: item.thumbnail) {
            thumbnailImageView.load(url: thumbnail)
        } else {
            thumbnailImageView.isSkeletonable = true
            thumbnailImageView.showSkeleton()
        }
    }
}
