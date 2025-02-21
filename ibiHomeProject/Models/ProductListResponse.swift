//
//  ProductListResponse.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//

import Foundation

struct ProductListResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}
