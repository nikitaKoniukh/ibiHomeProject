//
//  ProductTableViewCell1.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//

import UIKit
import SDWebImage

class ProductTableViewCell: UITableViewCell {
    
    static let identifier = "ProductTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("")
    }
    
    func configure(with product: Product) {
        titleLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        descriptionLabel.text = product.description
        brandLabel.text = product.brand
        loadImage(urlString: product.thumbnail)
    }
    
    private func loadImage(urlString: String) {
        productImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(systemName: "photo.artframe"))
    }
    
}
