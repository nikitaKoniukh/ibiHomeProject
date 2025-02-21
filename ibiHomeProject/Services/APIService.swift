//
//  APIService.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//

import Combine
import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "https://dummyjson.com/products"
    private init() {}
    
    func fetchProducts() -> AnyPublisher<ProductListResponse, Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ProductListResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
