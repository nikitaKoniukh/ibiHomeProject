//
//  FavoritesViewModel.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//

import Foundation
import Combine

class FavoritesViewModel {
    
    @Published var favorites: [ProductModel] = []

    
    init() {
        favorites = SwiftDataService.shared.productModels
    }
    
    func reloadData() {
        favorites = SwiftDataService.shared.productModels
    }

    func saveProduct(_ product: Product?) {
        if let product {
            SwiftDataService.shared.saveProduct(product)
        }
    }
    
    func deleteProduct(_ product: ProductModel?) {
        if let product {
            SwiftDataService.shared.deleteProduct(product)
            favorites = SwiftDataService.shared.productModels
        }
    }
}
