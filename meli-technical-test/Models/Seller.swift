//
//  Seller.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

/// Seller model
struct Seller: Codable {
    let id: Int
    let permalink: String
    let reputation: Reputation?
    
    enum CodingKeys: String, CodingKey {
        case id, permalink
        case reputation = "seller_reputation"
    }
}

/// Reputation model
struct Reputation: Codable {
    let transactions: Transactions
}

/// Transactions model
struct Transactions: Codable {
    let canceled: Int
    let completed: Int
    let ratings: Ratings
}

/// Ratings model
struct Ratings: Codable {
    let positive: Double
    let neutral: Double
    let negative: Double
}
