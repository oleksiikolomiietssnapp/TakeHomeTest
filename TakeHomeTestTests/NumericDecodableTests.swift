//
//  NumericDecodableTests.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import XCTest

@testable import TakeHomeTest

// Dummy struct to test decoding
private struct TestModel: Decodable {
    var price: Double

    enum CodingKeys: CodingKey {
        case price
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.price = try container.decodeNumeric(Double.self, forKey: .price)
    }
}

class NumericDecodableTests: XCTestCase {
    func testDecodeNumeric() throws {
        let jsonData = """
            {
                "price": 42.5
            }
            """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let model = try decoder.decode(TestModel.self, from: jsonData)

        XCTAssertEqual(model.price, 42.5, "Decoded value should be 42.5")
    }

    func testDecodeNumericFromString() throws {
        let jsonData = """
            {
                "price": "42.5"
            }
            """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let model = try decoder.decode(TestModel.self, from: jsonData)

        XCTAssertEqual(model.price, 42.5, "Decoded value should be 42.5")
    }

    func testDecodeInvalidNumeric() throws {
        let jsonData = """
            {
                "price": "invalid"
            }
            """.data(using: .utf8)!

        let decoder = JSONDecoder()

        XCTAssertThrowsError(try decoder.decode(TestModel.self, from: jsonData)) { error in
            guard case DecodingError.dataCorrupted(let context) = error else {
                XCTFail("Expected dataCorrupted error")
                return
            }
            XCTAssertEqual(context.debugDescription, "Expected Double or String containing Double")
        }
    }

    func testDecodeMissingNumeric() throws {
        let jsonData = """
            {}
            """.data(using: .utf8)!

        let decoder = JSONDecoder()

        XCTAssertThrowsError(try decoder.decode(TestModel.self, from: jsonData)) { error in
            guard case DecodingError.keyNotFound(let key, let context) = error else {
                XCTFail("Expected keyNotFound error")
                return
            }
            XCTAssertEqual(key.stringValue, "price")
            XCTAssertEqual(context.debugDescription, "Key 'price' not found")
        }
    }
}
