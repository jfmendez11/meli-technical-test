//
//  Item.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

struct Products: Codable {
    let items: [Item]
    enum CodingKeys: String, CodingKey {
        case items = "results"
    }
}

struct Item: Codable {
    let id: String
    let title: String
    let seller: Seller
    let price: Double?
    let salePrice: Double?
    let originalPrice: Double?
    let currency_id: String
    let sold_quantity: Int
    let available_quantity: Int
    let condition: String
    let permalink: URL
    let thumbnail: URL
    let accepts_mercadopago: Bool
    let address: Address
    let shipping: Shipping
    let category_id: String
}

struct Address: Codable {
    let state: String
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case state = "state_name"
        case city = "city_name"
    }
}

struct Shipping: Codable {
    let isFreeShipping: Bool
    
    enum CodingKeys: String, CodingKey {
        case isFreeShipping = "free_shipping"
    }
}
