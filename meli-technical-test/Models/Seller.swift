//
//  Seller.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

struct Seller: Codable {
    let id: Int
    let permalink: URL
    let reputation: Reputation
    
    enum CodingKeys: String, CodingKey {
        case id, permalink
        case reputation = "seller_reputation"
    }
}

struct Reputation: Codable {
    let transactions: Transactions
}

struct Transactions: Codable {
    let canceled: Int
    let completed: Int
    let ratings: Ratings
}

struct Ratings: Codable {
    let positive: Double
    let neutral: Double
    let negative: Double
}
