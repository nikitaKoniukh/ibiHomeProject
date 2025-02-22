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
    @Published private(set) var isLoading = false
    private var skip = 0
    private let limit = 30
    private var hasMoreProducts = true
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
    
    func numberOfProducts() -> Int {
        return products.count
    }
    
    
    func fetchProducts() {
        guard !isLoading, hasMoreProducts else { return }
        isLoading = true
        
        let urlString = "https://dummyjson.com/products?skip=\(skip)&limit=\(limit)"
        
        APIService.shared.fetchProducts(from: urlString)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    print("Error fetching products: \(error)")
                }
            }, receiveValue: { [weak self] newProducts in
                guard let self = self else { return }
                
                if newProducts.isEmpty {
                    self.hasMoreProducts = false
                } else {
                    self.products.append(contentsOf: newProducts)
                    self.skip += self.limit
                }
            })
            .store(in: &cancellables)
    }
}
