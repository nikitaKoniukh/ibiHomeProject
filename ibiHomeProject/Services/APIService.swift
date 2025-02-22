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
    private init() {}
    
    func fetchProducts(from urlString: String) -> AnyPublisher<[Product], Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProductListResponse.self, decoder: JSONDecoder())
            .map(\.products)
            .receive(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }
}
