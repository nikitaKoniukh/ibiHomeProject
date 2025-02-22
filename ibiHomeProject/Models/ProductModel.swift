//
//  ProductModel.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//


import SwiftData

@Model
class ProductModel {
    @Attribute(.unique) var id: Int
    var title: String
    var descriptionText: String
    var price: Double
    var brand: String?
    var thumbnail: String
    
    init(id: Int, title: String, description: String, price: Double, brand: String?, thumbnail: String) {
        self.id = id
        self.title = title
        self.descriptionText = description
        self.price = price
        self.brand = brand
        self.thumbnail = thumbnail
    }
}
