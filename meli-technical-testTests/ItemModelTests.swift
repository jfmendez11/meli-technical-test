//
//  ModelTests.swift
//  meli-technical-testTests
//
//  Created by Juan Felipe Méndez on 27/01/21.
//

import XCTest
@testable import meli_technical_test

class ItemModelTests: XCTestCase {
    
    var items: Data!
    let decoder = JSONDecoder()
    
    override func setUp() {
        super.setUp()
        let data = Data(from: "Items", bundle: Bundle(for: type(of: self)))
        items = data
    }
    
    func testJSONLoad() {
        guard let items = try? decoder.decode(Products.self, from: items) else {
            XCTFail("Could not load items")
            return
        }
        XCTAssertNotNil(items, "Items check")
    }
    
    func testItem() {
        guard let items = try? decoder.decode(Products.self, from: items) else {
            XCTFail("Could not load items")
            return
        }
        XCTAssertNotNil(items.items, "Items check")
        XCTAssertEqual(items.items.count, 50, "Result has 50 items")
        XCTAssertEqual(items.items[0].id, "MLA885091466", "Id check")
        XCTAssertEqual(items.items[0].title, "Motorola One Fusion 128 Gb Deep Sapphire Blue 4 Gb Ram", "Title check")
        XCTAssertNotNil(items.items[0].price, "Price is not nil")
        XCTAssertEqual(items.items[0].price, 29999, "Price check")
        XCTAssertEqual(items.items[0].soldQuantity, 5976, "Sold quantity check")
        XCTAssertEqual(items.items[0].availableQuantity, 523, "Available quantity check")
        XCTAssertEqual(items.items[0].condition, "new", "Condition check")
        XCTAssertNotNil(URL(string: items.items[0].permalink), "valid url check")
        XCTAssertEqual(items.items[0].permalink, "https://www.mercadolibre.com.ar/motorola-one-fusion-128-gb-deep-sapphire-blue-4-gb-ram/p/MLA16107869", "Permalink check")
        XCTAssertNotNil(URL(string: items.items[0].thumbnail), "valid url check")
        XCTAssertEqual(items.items[0].thumbnail, "http://http2.mlstatic.com/D_939063-MLA43751372595_102020-I.jpg", "Thumbnail check")
        XCTAssertTrue(items.items[0].isMercadopago, "Accepts Mercadopago check")
        XCTAssertEqual(items.items[0].categoryId, "MLA1055", "Category check")
    }
    
    func testAddress() {
        guard let items = try? decoder.decode(Products.self, from: items) else {
            XCTFail("Could not load items")
            return
        }
        let address = items.items[0].address
        XCTAssertEqual(address.city, "Villa Celina", "City check")
        XCTAssertEqual(address.state, "Buenos Aires", "State check")
    }
    
    func testShipping() {
        guard let items = try? decoder.decode(Products.self, from: items) else {
            XCTFail("Could not load items")
            return
        }
        let shipping = items.items[0].shipping
        XCTAssertTrue(shipping.isFreeShipping, "Check free shipping")
    }
    
    func testSeller() {
        guard let items = try? decoder.decode(Products.self, from: items) else {
            XCTFail("Could not load items")
            return
        }
        let seller = items.items[0].seller
        XCTAssertEqual(seller.id, 608846165, "Seller id check")
        XCTAssertNotNil(URL(string: items.items[0].permalink), "Seller valid url check")
        XCTAssertEqual(seller.permalink, "http://perfil.mercadolibre.com.ar/ELECTRONICAFLA", "State check")
    }
    
    func testTransactions() {
        guard let items = try? decoder.decode(Products.self, from: items) else {
            XCTFail("Could not load items")
            return
        }
        let transactions = items.items[0].seller.reputation?.transactions
        XCTAssertNotNil(transactions, "Transactions check")
        XCTAssertEqual(transactions?.completed, 202569, "Check completed transactions")
        XCTAssertEqual(transactions?.canceled, 9311, "Check canceled transactions")
    }
    
    func testReputation() {
        guard let items = try? decoder.decode(Products.self, from: items) else {
            XCTFail("Could not load items")
            return
        }
        let ratings = items.items[0].seller.reputation?.transactions.ratings
        XCTAssertNotNil(ratings, "Reputation is not nil")
        XCTAssertEqual(ratings?.positive, 0.9, "Check positive rating")
        XCTAssertEqual(ratings?.neutral, 0.03, "Check neutral rating")
        XCTAssertEqual(ratings?.negative, 0.07, "Check negative rating")
    }

}

extension Data {
    init(from json: String, bundle: Bundle = Bundle.main) {
        do {
            if let file = bundle.url(forResource: json, withExtension: "json") {
                try self.init(contentsOf: file)
                return
            }
        } catch {
            print(error.localizedDescription)
        }
        self.init()
    }
}
