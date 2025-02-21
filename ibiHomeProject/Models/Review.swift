//
//  Review.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//


struct Review: Codable {
    let rating: Int
    let comment: String
    let date: String
    let reviewerName: String
    let reviewerEmail: String
}