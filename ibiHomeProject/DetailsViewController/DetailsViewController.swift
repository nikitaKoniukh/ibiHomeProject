//
//  DetailsViewController.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 22/02/2025.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var changableStackView: UIStackView!
    @IBOutlet weak var unChangableStackview: UIStackView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tileLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var productModel: ProductModel?
    var product: Product?
    var onHandleClose: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let productModel {
            changableStackView.isHidden = false
            unChangableStackview.isHidden = true
            setUIForSaved(productModel: productModel)
            setupTextField()
        }
        
        if let product {
            changableStackView.isHidden = true
            unChangableStackview.isHidden = false
            setUI(product: product)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveProductModelIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onHandleClose?()
    }
    
    private func setupTextField() {
        titleTextField.delegate = self
        priceTextField.delegate = self
        brandTextField.delegate = self
        descriptionTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        saveProductModelIfNeeded()
    }
    
    private func setUIForSaved(productModel: ProductModel) {
        mainImageView.loadImage(from: productModel.thumbnail)
        titleTextField.text = productModel.title
        descriptionTextField.text = productModel.descriptionText
        priceTextField.text = "$\(productModel.price)"
        brandTextField.text = productModel.brand
    }
    
    private func setUI(product: Product) {
        mainImageView.loadImage(from: product.thumbnail )
        tileLabel.text = product.title
        descriptionLabel.text = product.description
        priceLabel.text = "$\(product.price)"
        brandLabel.text = product.brand
    }
    
    private func saveProductModelIfNeeded() {
        if let productModel {
            let newProductModel = ProductModel(
                id: productModel.id,
                title: titleTextField.text ?? "",
                description: descriptionTextField.text ?? "",
                price: Double(priceTextField.text?.replacingOccurrences(of: "$", with: "") ?? "0") ?? 0,
                brand: brandTextField.text ?? "", thumbnail: productModel.thumbnail)
            
            SwiftDataService.shared.updateProduct(newProductModel)
        }
    }
    
}

extension DetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveProductModelIfNeeded()
        return true
    }
}
