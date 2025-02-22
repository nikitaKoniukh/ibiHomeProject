//
//  ProductTableViewCell1.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//

import UIKit
import SDWebImage

protocol ProductTableViewCellDelegate: AnyObject {
    func favoriteSelected(for product: Product?)
    func favoriteDeSelected(for product: Product?)
}

class ProductTableViewCell: UITableViewCell {
    
    static let identifier = "ProductTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delelegate: ProductTableViewCellDelegate?
    private var product: Product?
    
    var saved: Bool = false {
        didSet {
            favoriteButton.setImage(UIImage(systemName: saved ? "star.fill" : "star"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("")
    }
    
    func configure(with product: Product?, saved: Bool) {
        self.product = product
        self.saved = saved
        favoriteButton.isHidden = false
        
        guard let product else {
            return
        }
        
        titleLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        descriptionLabel.text = product.description
        brandLabel.text = product.brand
        loadImage(urlString: product.thumbnail)
    }
    
    func configure(with savedProduct: ProductModel?) {
        favoriteButton.isHidden = true
        guard let product = savedProduct else {
            return
        }
        
        titleLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        descriptionLabel.text = product.descriptionText
        brandLabel.text = product.brand
        loadImage(urlString: product.thumbnail)
    }
    
    private func loadImage(urlString: String) {
        productImageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(systemName: "photo.artframe"))
    }
    
    @IBAction func favoritesButtonPressed(_ sender: UIButton) {
        saved.toggle()
        
        if saved {
            delelegate?.favoriteSelected(for: product)
        } else {
            delelegate?.favoriteDeSelected(for: product)
        }
    }
    
}
