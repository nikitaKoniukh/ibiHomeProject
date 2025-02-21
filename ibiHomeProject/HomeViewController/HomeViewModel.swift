//
//  HomeViewModel.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var products: [Product] = []
    private var cancellables = Set<AnyCancellable>()
    
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
