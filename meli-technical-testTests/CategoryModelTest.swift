//
//  CategoryModelTest.swift
//  meli-technical-testTests
//
//  Created by Juan Felipe Méndez on 27/01/21.
//

import XCTest
@testable import meli_technical_test

class CategoryModelTest: XCTestCase {
    var categories: Data!
    let decoder = JSONDecoder()
    
    override func setUp() {
        super.setUp()
        let data = Data(from: "Categories", bundle: Bundle(for: type(of: self)))
        categories = data
    }
    
    func testJSONLoad() {
        guard let categories = try? decoder.decode([meli_technical_test.Category].self, from: categories) else {
            XCTFail("Could not load categories")
            return
        }
        XCTAssertNotNil(categories, "categories check")
    }
    
    func testCategory() {
        guard let categories = try? decoder.decode([meli_technical_test.Category].self, from: categories) else {
            XCTFail("Could not load categories")
            return
        }
        XCTAssertEqual(categories.count, 28, "Result has 28 categories")
        XCTAssertEqual(categories[0].id, "MLA5725", "Category id check")
        XCTAssertEqual(categories[0].name, "Accesorios para Vehículos", "Category name check")
    }
}
