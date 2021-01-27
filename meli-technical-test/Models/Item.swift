//
//  Item.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

/// Products model, casts the items from the response
struct Products: Codable {
    let items: [Item]
    enum CodingKeys: String, CodingKey {
        case items = "results"
    }
}

/// Item model
struct Item: Codable {
    let id: String
    let title: String
    let seller: Seller
    let price: Double?
    let soldQuantity: Int
    let availableQuantity: Int
    let condition: String
    let permalink: String
    let thumbnail: String
    let isMercadopago: Bool
    let address: Address
    let shipping: Shipping
    let categoryId: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, seller, price, condition, permalink, thumbnail, address, shipping
        case soldQuantity = "sold_quantity"
        case availableQuantity = "available_quantity"
        case isMercadopago = "accepts_mercadopago"
        case categoryId = "category_id"
    }
}

/// Address model
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
