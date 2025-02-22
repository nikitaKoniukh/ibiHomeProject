//
//  HomeViewModel.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//

import Foundation
import Combine
import SwiftData

class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    private var cancellables = Set<AnyCancellable>()

    func isProductSaved(_ product: Product?) -> Bool {
        if let product {
            return SwiftDataService.shared.productModels.contains(where: { $0.id == product.id })
        }
        
        return false
    }
    
    func saveProduct(_ product: Product?) {
        if let product {
            SwiftDataService.shared.saveProduct(product)
        }
    }
    
    func deleteProduct(_ product: Product?) {
        if let product {
            SwiftDataService.shared.deleteProduct(product)
        }
    }
    
    func fetchProducts() {
        APIService.shared.fetchProducts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("\(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.products = response.products
            })
            .store(in: &cancellables)
    }
}
