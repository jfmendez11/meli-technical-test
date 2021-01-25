//
//  Site.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import Foundation

struct Site: Codable {
    let id: String
    let currency: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case currency = "default_currency_id"
        case country = "name"
    }
}
